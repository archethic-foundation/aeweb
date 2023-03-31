/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'website_selection.freezed.dart';

@freezed
class WebsiteSelection with _$WebsiteSelection {
  const factory WebsiteSelection({
    required String name,
    required String genesisAddress,
  }) = _WebsiteSelection;
}
