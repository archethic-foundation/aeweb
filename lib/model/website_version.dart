/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'website_version.freezed.dart';

@freezed
class WebsiteVersion with _$WebsiteVersion {
  const factory WebsiteVersion({
    required String transactionRefAddress,
    required int timestamp,
    @Default('') String publisher,
    @Default(0) int filesCount,
    @Default(0) int size,
    HostingRef? content,
    X509CertificateData? sslCertificate,
  }) = _WebsiteVersion;
}
