/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:developer';

import 'package:aeweb/application/session/state.dart';
import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/util/browser_util_desktop.dart'
    if (dart.library.js) 'package:aeweb/util/browser_util_web.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class _SessionNotifier extends Notifier<Session> {
  StreamSubscription? connectionStatusSubscription;

  @override
  Session build() {
    ref.onDispose(() {
      log('dispose SessionNotifier');
      connectionStatusSubscription?.cancel();
    });
    return const Session();
  }

  void _handleConnectionFailure(bool isBrave) {
    state = state.copyWith(
      isConnected: false,
      error: isBrave
          ? "Please, open your Archethic Wallet and disable Brave's shield."
          : 'Please, open your Archethic Wallet.',
    );
  }

  Future<void> connectToWallet() async {
    final isBrave = BrowserUtil().isBraveBrowser();

    try {
      await aedappfm.sl.get<DBHelper>().clearWebsites();
      state = state.copyWith(
        isConnected: false,
        error: '',
      );

      awc.ArchethicDAppClient? archethicDAppClient;
      try {
        archethicDAppClient = awc.ArchethicDAppClient.websocket(
          origin: const awc.RequestOrigin(
            name: 'aeHosting',
          ),
        );
      } catch (e) {
        throw const aedappfm.Failure.connectivityArchethic();
      }

      await archethicDAppClient.connect();
      final endpointResponse = await archethicDAppClient.getEndpoint();
      await endpointResponse.when(
        failure: (failure) {
          _handleConnectionFailure(isBrave);
        },
        success: (result) async {
          log('DApp is connected to archethic wallet.');

          if (FeatureFlags.mainnetActive == false &&
              result.endpointUrl == 'https://mainnet.archethic.net') {
            state = state.copyWith(
              isConnected: false,
              error:
                  'AEWeb is not currently available on the Archethic mainnet.',
            );
            return;
          }

          state = state.copyWith(endpoint: result.endpointUrl);
          connectionStatusSubscription =
              archethicDAppClient!.connectionStateStream.listen((event) {
            event.when(
              disconnected: () {
                log('Disconnected', name: 'Wallet connection');
                state = state.copyWith(
                  endpoint: '',
                  error: '',
                  genesisAddress: '',
                  nameAccount: '',
                  oldNameAccount: '',
                  isConnected: false,
                );
              },
              connected: () async {
                log('Connected', name: 'Wallet connection');
                state = state.copyWith(
                  isConnected: true,
                  error: '',
                );
              },
              connecting: () {
                log('Connecting', name: 'Wallet connection');
                state = state.copyWith(
                  endpoint: '',
                  error: '',
                  genesisAddress: '',
                  nameAccount: '',
                  oldNameAccount: '',
                  isConnected: false,
                );
              },
            );
          });
          if (aedappfm.sl.isRegistered<ApiService>()) {
            aedappfm.sl.unregister<ApiService>();
          }
          if (aedappfm.sl.isRegistered<OracleService>()) {
            aedappfm.sl.unregister<OracleService>();
          }
          if (aedappfm.sl.isRegistered<ArchethicDAppClient>()) {
            aedappfm.sl.unregister<ArchethicDAppClient>();
          }
          aedappfm.sl.registerLazySingleton<ArchethicDAppClient>(
            () => archethicDAppClient!,
          );
          setupServiceLocatorApiService(result.endpointUrl);
          final subscription =
              await archethicDAppClient.subscribeCurrentAccount();

          await subscription.when(
            success: (success) async {
              state = state.copyWith(
                accountSub: success,
                error: '',
                isConnected: true,
                accountStreamSub: success.updates.listen((event) {
                  if (event.name.isEmpty && event.genesisAddress.isEmpty) {
                    state = state.copyWith(
                      oldNameAccount: state.nameAccount,
                      genesisAddress: event.genesisAddress,
                      nameAccount: event.name,
                      error: 'Please, open your Archethic Wallet.',
                      isConnected: false,
                    );
                    return;
                  }
                  state = state.copyWith(
                    oldNameAccount: state.nameAccount,
                    genesisAddress: event.genesisAddress,
                    nameAccount: event.name,
                  );
                }),
              );
            },
            failure: (failure) {
              state = state.copyWith(
                isConnected: false,
                error: failure.message ?? 'Connection failed',
              );
            },
          );
        },
      );
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        isConnected: false,
        error: 'Please, open your Archethic Wallet.',
      );
    }
  }

  void setOldNameAccount() {
    state = state.copyWith(oldNameAccount: state.nameAccount);
  }

  Future<void> cancelConnection() async {
    await aedappfm.sl.get<ArchethicDAppClient>().close();
    await aedappfm.sl.get<DBHelper>().clearWebsites();
    log('Unregister', name: 'ApiService');
    if (aedappfm.sl.isRegistered<ApiService>()) {
      aedappfm.sl.unregister<ApiService>();
    }

    state = state.copyWith(
      accountSub: null,
      accountStreamSub: null,
      nameAccount: '',
      genesisAddress: '',
    );
  }
}

abstract class SessionProviders {
  static final session = _sessionNotifierProvider;
}
