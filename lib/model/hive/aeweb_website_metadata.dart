/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:hive/hive.dart';

part 'aeweb_website_metadata.g.dart';

/// Next field available : 5
@HiveType(typeId: 4)
class AEWebLocalWebsiteMetaData extends HiveObject {
  AEWebLocalWebsiteMetaData({
    required this.hash,
    required this.size,
    required this.encoding,
    required this.addresses,
  });

  AEWebLocalWebsiteMetaData copyWith({
    String? hash,
    int? size,
    String? encoding,
    List<String>? addresses,
  }) =>
      AEWebLocalWebsiteMetaData(
        hash: hash ?? this.hash,
        size: size ?? this.size,
        encoding: encoding ?? this.encoding,
        addresses: addresses ?? this.addresses,
      );

  /// Hash
  @HiveField(0)
  final String hash;

  /// Size
  @HiveField(1)
  final int size;

  /// Encoding
  @HiveField(3)
  final String encoding;

  /// Addresses
  @HiveField(4)
  final List<String> addresses;
}
