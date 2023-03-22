import 'dart:developer';
import 'dart:io';

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
    String path,
  ) async {
    final hostingContentMetaData = <String, HostingContentMetaData>{};
    try {
      final directory = Directory(path);
      if (directory.existsSync()) {
        for (final entity in directory.listSync(recursive: true)) {
          if (entity is File) {
            final contentBytes = await entity.readAsBytes();
            final contentHash = sha1.convert(contentBytes).toString();
            final filePath = entity.path.replaceAll(path, '');
            final fileSize = await entity.length();
            hostingContentMetaData[filePath] = HostingContentMetaData(
              hash: contentHash,
              encoding: 'gzip',
              size: fileSize,
            );
          }
        }
      }
    } catch (e) {
      log('Error while retrieving files and folders : $e');
    }
    return hostingContentMetaData;
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
