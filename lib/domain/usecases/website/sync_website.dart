import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:aeweb/util/ignore.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_website.freezed.dart';

enum HostingContentComparisonStatus {
  localOnly,
  remoteOnly,
  differentContent,
  sameContent,
}

@freezed
class HostingContentComparison with _$HostingContentComparison {
  const factory HostingContentComparison({
    required String path,
    required HostingContentComparisonStatus status,
  }) = _HostingContentComparison;
}

class SyncWebsiteUseCases {
  Future<Map<String, HostingContentMetaData>>? listFilesFromPath(
    String path, {
    bool applyGitIgnoreRules = true,
  }) async {
    final hostingContentMetaData = <String, HostingContentMetaData>{};
    final hostingContentMetaDataFiltered = <String, HostingContentMetaData>{};
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

            hostingContentMetaData[filePath] = HostingContentMetaData(
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

          hostingContentMetaData.forEach((key, value) {
            if (ignore.ignores(key) == false) {
              hostingContentMetaDataFiltered[key] = value;
            }
          });
        }
      }
    } catch (e) {
      log('Error while retrieving files and folders : $e');
    }
    return hostingContentMetaDataFiltered;
  }

  List<HostingContentComparison> compareFileLists(
    Map<String, HostingContentMetaData> localFiles,
    Map<String, HostingContentMetaData> remoteFiles,
  ) {
    final comparedFiles = <HostingContentComparison>[];
    localFiles.forEach((localPath, localMetaData) {
      final remoteMetaData = remoteFiles[localPath];
      if (remoteMetaData == null) {
        comparedFiles.add(
          HostingContentComparison(
            path: localPath,
            status: HostingContentComparisonStatus.localOnly,
          ),
        );
      } else if (localMetaData.hash != remoteMetaData.hash) {
        comparedFiles.add(
          HostingContentComparison(
            path: localPath,
            status: HostingContentComparisonStatus.differentContent,
          ),
        );
      } else {
        comparedFiles.add(
          HostingContentComparison(
            path: localPath,
            status: HostingContentComparisonStatus.sameContent,
          ),
        );
      }
    });

    remoteFiles.forEach((remotePath, remoteMetaData) {
      if (!localFiles.containsKey(remotePath)) {
        comparedFiles.add(
          HostingContentComparison(
            path: remotePath,
            status: HostingContentComparisonStatus.remoteOnly,
          ),
        );
      }
    });

    comparedFiles.sort((a, b) => a.path.compareTo(b.path));
    return comparedFiles;
  }
}
