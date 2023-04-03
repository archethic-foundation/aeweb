import 'dart:developer';

import 'package:aeweb/application/session/state.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class _SessionNotifier extends Notifier<Session> {
  @override
  Session build() {
    return const Session();
  }

  Future<void> connectToWallet() async {
    final endpointResponse = await sl.get<ArchethicDAppClient>().getEndpoint();
    endpointResponse.when(
      failure: (failure) {
        switch (failure.code) {
          case 4901:
            state = state.copyWith(
              error: 'Please, open your Archethic Wallet.',
            );
            break;
          default:
            state = state.copyWith(
              error: failure.message ?? 'Connection failed',
            );
        }
      },
      success: (result) async {
        log('DApp is connected to archethic wallet.');
        state = state.copyWith(endpoint: result.endpointUrl);
        await setupServiceLocatorApiService(result.endpointUrl);

        final subscription =
            await sl.get<ArchethicDAppClient>().subscribeCurrentAccount();

        subscription.when(
          success: (success) async {
            state = state.copyWith(
              accountSub: success,
              accountStreamSub: success.updates.listen((event) {
                state = state.copyWith(
                  genesisAddress: event.genesisAddress,
                  nameAccount: event.name,
                );
              }),
            );
          },
          failure: (failure) {
            state = state.copyWith(
              error: failure.message ?? 'Connection failed',
            );
          },
        );
      },
    );
  }

  Future<void> cancelConnection() async {
    state = state.copyWith(accountSub: null, accountStreamSub: null);
  }
}

abstract class SessionProviders {
  static final session = _sessionNotifierProvider;
}