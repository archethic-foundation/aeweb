/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required Environment environment,
    @Default('') String nameAccount,
    @Default('') String genesisAddress,
    @Default('') String error,
    required ArchethicDappConnectionState walletConnectionState,
    Subscription<Account>? accountSub,
    StreamSubscription<Account>? accountStreamSub,
  }) = _Session;
  const Session._();

  bool get isConnected =>
      walletConnectionState == const ArchethicDappConnectionState.connected();
}
