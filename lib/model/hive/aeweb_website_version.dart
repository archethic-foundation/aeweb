/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/hive/aeweb_website_metadata.dart';
import 'package:hive/hive.dart';

part 'aeweb_website_version.g.dart';

/// Next field available : 7
@HiveType(typeId: 2)
class AEWebLocalWebsiteVersion extends HiveObject {
  AEWebLocalWebsiteVersion({
    required this.transactionAddress,
    required this.timestamp,
    this.filesCount,
    this.size,
    this.structureVersion,
    this.hashFunction,
    this.metaData,
  });

  AEWebLocalWebsiteVersion copyWith({
    String? transactionAddress,
    int? timestamp,
    int? filesCount,
    int? size,
    int? structureVersion,
    String? hashFunction,
    Map<String, AEWebLocalWebsiteMetaData>? metaData,
  }) =>
      AEWebLocalWebsiteVersion(
        transactionAddress: transactionAddress ?? this.transactionAddress,
        timestamp: timestamp ?? this.timestamp,
        filesCount: filesCount ?? this.filesCount,
        size: size ?? this.size,
        structureVersion: structureVersion ?? this.structureVersion,
        hashFunction: hashFunction ?? this.hashFunction,
        metaData: metaData ?? this.metaData,
      );

  /// Website version's address
  @HiveField(0)
  final String transactionAddress;

  /// Version's timestamp
  @HiveField(1)
  final int timestamp;

  /// Nb of files
  @HiveField(2)
  final int? filesCount;

  /// Version's size
  @HiveField(3)
  final int? size;

  /// Version of structure
  @HiveField(4)
  final int? structureVersion;

  /// Hash function used
  @HiveField(5)
  final String? hashFunction;

  /// MetaData
  @HiveField(6)
  final Map<String, AEWebLocalWebsiteMetaData>? metaData;
}
