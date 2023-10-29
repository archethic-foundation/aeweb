/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:developer';

import 'package:aeweb/application/session/state.dart';
import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
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

  Future<void> connectToWallet() async {
    try {
      await sl.get<DBHelper>().clearWebsites();
      state = state.copyWith(
        isConnected: false,
        error: '',
      );

      final archethicDAppClient = ArchethicDAppClient.auto(
        origin: const RequestOrigin(
          name: 'AEWeb',
        ),
        replyBaseUrl: 'aeweb://archethic.tech',
      );

      final endpointResponse = await archethicDAppClient.getEndpoint();
      endpointResponse.when(
        failure: (failure) {
          switch (failure.code) {
            case 4901:
              state = state.copyWith(
                isConnected: false,
                error: 'Please, open your Archethic Wallet.',
              );
              break;
            default:
              log(failure.message ?? 'Connection failed');
              state = state.copyWith(
                isConnected: false,
                error: 'Please, open your Archethic Wallet.',
              );
          }
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
              archethicDAppClient.connectionStateStream.listen((event) {
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
          if (sl.isRegistered<ApiService>()) {
            sl.unregister<ApiService>();
          }
          if (sl.isRegistered<OracleService>()) {
            sl.unregister<OracleService>();
          }
          if (sl.isRegistered<ArchethicDAppClient>()) {
            sl.unregister<ArchethicDAppClient>();
          }
          sl.registerLazySingleton<ArchethicDAppClient>(
            () => archethicDAppClient,
          );
          setupServiceLocatorApiService(result.endpointUrl);
          final subscription =
              await archethicDAppClient.subscribeCurrentAccount();

          subscription.when(
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
    await sl.get<ArchethicDAppClient>().close();
    await sl.get<DBHelper>().clearWebsites();
    log('Unregister', name: 'ApiService');
    if (sl.isRegistered<ApiService>()) {
      sl.unregister<ApiService>();
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
