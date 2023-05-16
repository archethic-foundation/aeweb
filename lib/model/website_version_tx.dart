/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'website_version_tx.freezed.dart';

@freezed
class WebsiteVersionTx with _$WebsiteVersionTx {
  const factory WebsiteVersionTx({
    required String address,
    required String typeHostingTx,
  }) = _WebsiteVersionTx;
}
