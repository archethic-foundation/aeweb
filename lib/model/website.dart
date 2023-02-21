/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'website.freezed.dart';

@freezed
class Website with _$Website {
  const factory Website({
    required String name,
    required String genesisAddress,
    required String size,
    required String nbTransactions,
    required String lastPublicationFees,
    required String globalFees,
  }) = _Website;
}
