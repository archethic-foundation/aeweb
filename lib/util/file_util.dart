import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:aeweb/util/ignore.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';

// 3 145 728 represent the maximum size for a transaction
// 45 728 represent json tree size
// 3mb in binary
const kMaxFileSize = 3145728 - 45728;

mixin FileMixin {
  static Future<Map<String, HostingRefContentMetaData>>? listFilesFromPath(
    String path, {
    bool applyGitIgnoreRules = true,
  }) async {
    final hostingRefContentMetaData = <String, HostingRefContentMetaData>{};
    final hostingRefContentMetaDataFiltered =
        <String, HostingRefContentMetaData>{};
    try {
      final directory = Directory(path);
      final gitIgnoreContent = StringBuffer();
      if (directory.existsSync()) {
        for (final entity in directory.listSync(recursive: true)) {
          if (entity is File && entity.path.contains('/.git/') == false) {
            final contentBytes = await entity.readAsBytes();
            final contentHash = sha1.convert(contentBytes).toString();
            final filePath = entity.path.replaceAll(path, '');
            final fileSize = await entity.length();

            if (applyGitIgnoreRules &&
                filePath.split('/').last == '.gitignore') {
              gitIgnoreContent.write(
                utf8.decode(
                  Uint8List.fromList(contentBytes),
                ),
              );
            }

            hostingRefContentMetaData[filePath] = HostingRefContentMetaData(
              hash: contentHash,
              encoding: 'gzip',
              size: fileSize,
            );
          }
        }

        if (applyGitIgnoreRules && gitIgnoreContent.isNotEmpty) {
          log(gitIgnoreContent.toString());
          final ignore = Ignore(
            [gitIgnoreContent.toString()],
            ignoreCase: true,
          );

          hostingRefContentMetaData.forEach((key, value) {
            if (ignore.ignores(key) == false) {
              hostingRefContentMetaDataFiltered[key] = value;
            }
          });
        } else {
          return hostingRefContentMetaData;
        }
      }
    } catch (e) {
      log('Error while retrieving files and folders : $e');
    }
    return hostingRefContentMetaDataFiltered;
  }

  static Future<Map<String, HostingRefContentMetaData>?> listFilesFromZip(
    Uint8List zipData, {
    bool applyGitIgnoreRules = true,
  }) async {
    final hostingRefContentMetaData = <String, HostingRefContentMetaData>{};
    final hostingRefContentMetaDataFiltered =
        <String, HostingRefContentMetaData>{};
    final archive = ZipDecoder().decodeBytes(zipData);

    try {
      final gitIgnoreContent = StringBuffer();

      for (final file in archive) {
        if (!file.isFile) continue;

        final contentBytes = file.content;
        final contentHash = sha1.convert(contentBytes).toString();
        final filePath = file.name;
        final fileSize = contentBytes.length;

        if (applyGitIgnoreRules && filePath.split('/').last == '.gitignore') {
          gitIgnoreContent.write(utf8.decode(contentBytes));
        }

        hostingRefContentMetaData[filePath] = HostingRefContentMetaData(
          hash: contentHash,
          encoding: 'gzip',
          size: fileSize,
        );
      }

      if (applyGitIgnoreRules && gitIgnoreContent.isNotEmpty) {
        log(gitIgnoreContent.toString());
        final ignore = Ignore([gitIgnoreContent.toString()], ignoreCase: true);

        hostingRefContentMetaData.forEach((key, value) {
          if (!ignore.ignores(key)) {
            hostingRefContentMetaDataFiltered[key] = value;
          }
        });
      } else {
        return hostingRefContentMetaData;
      }
    } catch (e) {
      log('Error while retrieving files and folders: $e');
    }

    return hostingRefContentMetaDataFiltered;
  }

  List<Map<String, dynamic>> setContentsFromPath(
    String path,
    List<String> files,
  ) {
    var txsContent = <Map<String, dynamic>>[];
    for (final file in files) {
      final fileLoaded = File(path + file);
      if (fileLoaded.existsSync()) {
        final encodedContent = encodeContent(fileLoaded.readAsBytesSync());
        if (encodedContent.length >= kMaxFileSize) {
          txsContent = handleBigFile(txsContent, file, encodedContent);
        } else {
          txsContent = handleNormalFile(txsContent, file, encodedContent);
        }
      }
    }
    return txsContent;
  }

  List<Map<String, dynamic>> setContentsFromZip(
    Uint8List zipData,
    List<String> files,
  ) {
    var txsContent = <Map<String, dynamic>>[];
    final archive = ZipDecoder().decodeBytes(zipData);

    for (final file in files) {
      final archiveFile = archive.firstWhere(
        (entry) => entry.name == file,
      );
      if (!archiveFile.isFile) continue;

      final encodedContent = encodeContent(
        Uint8List.fromList(archiveFile.content),
      );
      if (encodedContent.length >= kMaxFileSize) {
        txsContent = handleBigFile(txsContent, file, encodedContent);
      } else {
        txsContent = handleNormalFile(txsContent, file, encodedContent);
      }
    }

    return txsContent;
  }

  String encodeContent(Uint8List rawData) {
    final compressedData = GZipEncoder().encode(rawData);
    return base64Url.encode(compressedData!);
  }

  Uint8List decodeContent(String data) {
    final compressedData = base64Url.decode(data);
    return Uint8List.fromList(
      GZipDecoder().decodeBytes(compressedData),
    );
  }

  List<Map<String, dynamic>> handleBigFile(
    List<Map<String, dynamic>> txsContent,
    String filePath,
    String content,
  ) {
    var _content = content;
    while (_content.isNotEmpty) {
      // Split the file
      // Replace with desired max file size
      String part;
      if (_content.length > kMaxFileSize) {
        part = _content.substring(0, kMaxFileSize);
      } else {
        part = _content;
      }
      _content = _content.replaceFirst(part, '');
      // Set the value in transaction content
      final txContent = <String, dynamic>{
        'content': {},
        'size': part.length,
        'refPath': [],
      };
      txContent['content'][filePath] = part;
      txContent['refPath'].add(filePath);
      txsContent.add(txContent);
    }
    return txsContent;
  }

  List<Map<String, dynamic>> handleNormalFile(
    List<Map<String, dynamic>> txsContent,
    String filePath,
    String content,
  ) {
    // 4 x "inverted commas + 1x :Colon + 1x ,Comma + 1x space = 7
    final fileSize = content.length + filePath.length + 7;
    // Get first transaction content that can be filled with file content
    final txContent = getContentToFill(txsContent, fileSize);
    final index = txsContent.indexOf(txContent);

    txContent['content'][filePath] = content;
    txContent['refPath'].add(filePath);
    txContent['size'] += fileSize;

    if (index == -1) {
      // Push new transaction
      txsContent.add(txContent);
    } else {
      // Update existing transaction
      txsContent[index] = txContent;
    }
    return txsContent;
  }

  Map<String, dynamic> getContentToFill(
    List<Map<String, dynamic>> txsContent,
    int contentSize,
  ) {
    final content = txsContent.firstWhereOrNull(
      (txContent) => (txContent['size'] + contentSize) <= kMaxFileSize,
    );
    if (content != null) {
      return content;
    } else {
      return {
        'content': {},
        'size': 0,
        'refPath': [],
      };
    }
  }

  Future<bool> isGitignoreExist({
    required String path,
  }) async {
    const gitignoreExist = false;
    try {
      final directory = Directory(path);
      if (directory.existsSync()) {
        for (final entity in directory.listSync(recursive: true)) {
          if (entity is File && entity.path.contains('/.git/') == false) {
            final filePath = entity.path.replaceAll(path, '');
            if (filePath.split('/').last == '.gitignore') {
              return true;
            }
          }
        }
      }
    } catch (e) {
      log('Error while retrieving files and folders : $e');
    }
    return gitignoreExist;
  }
}
