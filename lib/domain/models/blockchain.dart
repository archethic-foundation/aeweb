/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blockchain.freezed.dart';
part 'blockchain.g.dart';

@freezed
class Blockchain with _$Blockchain {
  const factory Blockchain({
    @Default('') String name,
    @Default('') String env,
    @Default('') String icon,
    @Default('') String urlExplorerAddress,
    @Default('') String urlExplorerTransaction,
    @Default('') String urlExplorerChain,
    @Default('') String nativeCurrency,
  }) = _Blockchain;

  const Blockchain._();

  factory Blockchain.fromJson(Map<String, dynamic> json) =>
      _$BlockchainFromJson(json);
}
