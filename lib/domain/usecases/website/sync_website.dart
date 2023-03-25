import 'package:archethic_lib_dart/archethic_lib_dart.dart';
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
  List<HostingContentComparison> compareFileLists(
    Map<String, HostingRefContentMetaData> localFiles,
    Map<String, HostingRefContentMetaData> remoteFiles,
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
