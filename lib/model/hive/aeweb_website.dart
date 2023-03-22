/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/hive/aeweb_website_version.dart';
import 'package:hive/hive.dart';

part 'aeweb_website.g.dart';

/// Next field available : 5
@HiveType(typeId: 1)
class AEWebLocalWebsite extends HiveObject {
  AEWebLocalWebsite({
    required this.name,
    required this.genesisAddress,
    this.lastSaving,
    this.localPath,
    this.aewebLocalWebsiteVersionList,
  });

  AEWebLocalWebsite copyWith({
    String? name,
    String? genesisAddress,
    int? lastSaving,
    String? localPath,
    List<AEWebLocalWebsiteVersion>? aewebLocalWebsiteVersionList,
  }) =>
      AEWebLocalWebsite(
        name: name ?? this.name,
        genesisAddress: genesisAddress ?? this.genesisAddress,
        lastSaving: lastSaving ?? this.lastSaving,
        localPath: localPath ?? this.localPath,
        aewebLocalWebsiteVersionList:
            aewebLocalWebsiteVersionList ?? this.aewebLocalWebsiteVersionList,
      );

  /// Website name
  @HiveField(0)
  final String name;

  /// Genesis Address
  @HiveField(1)
  final String genesisAddress;

  /// Last saving of website in local
  @HiveField(2)
  final int? lastSaving;

  /// Local path where website is stored in local used for sync
  @HiveField(3)
  final String? localPath;

  /// Content
  @HiveField(4)
  final List<AEWebLocalWebsiteVersion>? aewebLocalWebsiteVersionList;
}
