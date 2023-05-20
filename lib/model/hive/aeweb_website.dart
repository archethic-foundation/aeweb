/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:hive/hive.dart';

part 'aeweb_website.g.dart';

/// Next field available : 5
@HiveType(typeId: 1)
class AEWebLocalWebsite extends HiveObject {
  AEWebLocalWebsite({
    required this.name,
    required this.genesisAddress,
    this.lastSaving,
  });

  AEWebLocalWebsite copyWith({
    String? name,
    String? genesisAddress,
    int? lastSaving,
    String? localPath,
  }) =>
      AEWebLocalWebsite(
        name: name ?? this.name,
        genesisAddress: genesisAddress ?? this.genesisAddress,
        lastSaving: lastSaving ?? this.lastSaving,
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
}
