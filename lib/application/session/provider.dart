/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:developer';

import 'package:aeweb/application/dapp_client.dart';
import 'package:aeweb/application/session/state.dart';
import 'package:aeweb/util/browser_util_desktop.dart'
    if (dart.library.js) 'package:aeweb/util/browser_util_web.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Environment environment(Ref ref) => ref.watch(
      sessionNotifierProvider.select(
        (session) => session.environment,
      ),
    );

@riverpod
class SessionNotifier extends _$SessionNotifier {
  SessionNotifier();

  StreamSubscription<ArchethicDappConnectionState>?
      _connectionStateSubscription;

  Completer? _connectionCompleter;
  StreamSubscription<ArchethicDappConnectionState>?
      _connectionTaskStateSubscription;

  @override
  Session build() {
    ref.onDispose(() {
      _connectionStateSubscription?.cancel();
    });

    ref.watch(dappClientProvider).when(
      data: (dappClient) {
        _listenConnectionState(dappClient);

        Future.delayed(
          const Duration(milliseconds: 50),
          connectWallet,
        );
      },
      loading: () {
        print('loading');
      },
      error: (error, stack) {
        print('error');
      },
    );
    return const Session(
      environment: Environment.mainnet,
      walletConnectionState: awc.ArchethicDappConnectionState.disconnected(),
    );
  }

  /// Connects to AEWallet, and waits for
  /// connection to succeed or fail.
  Future<void> connectWallet() async {
    if (_connectionCompleter != null) return _connectionCompleter!.future;

    /// In case there was no transport available on previous connection attempt,
    /// We force a new client creation from scratch.
    if (ref.exists(dappClientProvider) &&
        ref.read(dappClientProvider).hasError) {
      ref.invalidate(dappClientProvider);
    }
    final dappClientAsync = ref.read(dappClientProvider);

    if (dappClientAsync is! AsyncData || dappClientAsync.value == null) {
      return Future.error('Dapp client not ready or null');
    }

    final dappClient = dappClientAsync.value!;

    _connectionCompleter = Completer();
    _connectionTaskStateSubscription =
        dappClient.connectionStateStream.listen((connectionState) {
      connectionState.maybeWhen(
        connected: () {
          _connectionCompleter?.complete();
          _connectionCompleter = null;
          _connectionTaskStateSubscription?.cancel();
          _connectionTaskStateSubscription = null;
        },
        orElse: () {
          _connectionCompleter?.complete();
          _connectionCompleter = null;
          _connectionTaskStateSubscription?.cancel();
          _connectionTaskStateSubscription = null;
        },
      );
    });

    try {
      await dappClient.connect();
    } catch (e) {
      _handleConnectionFailure();
    }

    return _connectionCompleter?.future;
  }

  void _listenConnectionState(ArchethicDAppClient dappClient) {
    _connectionStateSubscription =
        dappClient.connectionStateStream.listen((connectionState) {
      connectionState.maybeWhen(
        disconnected: _onWalletDisconnected,
        connected: () => _onWalletConnected(dappClient),
        orElse: () => update(
          (state) => state.copyWith(walletConnectionState: connectionState),
        ),
      );
    });
  }

  Future<void> _onWalletDisconnected() async {
    state = const Session(
      environment: Environment.mainnet,
      walletConnectionState: awc.ArchethicDappConnectionState.disconnected(),
    );
  }

  Future<void> _onWalletConnected(ArchethicDAppClient dappClient) async {
    log('Wallet connected');
    try {
      final endpointResult = await dappClient.getEndpoint().valueOrThrow;
      final environment = Environment.byEndpoint(endpointResult.endpointUrl);

      final currentAccount = await dappClient.getCurrentAccount().valueOrNull;

      final subscription = await dappClient.subscribeCurrentAccount();

      await subscription.when(
        success: (success) async => update(
          (state) => state.copyWith(
            environment: environment,
            walletConnectionState:
                const awc.ArchethicDappConnectionState.connected(),
            error: '',
            genesisAddress:
                currentAccount?.genesisAddress ?? state.genesisAddress,
            nameAccount: currentAccount?.shortName ?? state.nameAccount,
            accountSub: success,
            accountStreamSub: success.updates.listen(
              (event) {
                update(
                  (state) => state.copyWith(
                    genesisAddress: event.genesisAddress,
                    nameAccount: event.name,
                  ),
                );
              },
            ),
          ),
        ),
        failure: (failure) async {
          state = state.copyWith(
            walletConnectionState:
                const awc.ArchethicDappConnectionState.disconnected(),
            error: failure.message,
          );
        },
      );
    } catch (e) {
      log('Error Wallet connection $e');
      _handleConnectionFailure();
    }
  }

  void _handleConnectionFailure() {
    update((state) {
      final isBrave = BrowserUtil().isBraveBrowser();
      return state.copyWith(
        walletConnectionState:
            const awc.ArchethicDappConnectionState.disconnected(),
        error: isBrave
            ? "Please, open your Archethic Wallet and disable Brave's shield."
            : 'Please, open your Archethic Wallet.',
      );
    });
  }

  Future<void> cancelConnection() async {
    state = state.copyWith(
      walletConnectionState:
          const awc.ArchethicDappConnectionState.disconnected(),
    );

    final dappClientAsync = ref.read(dappClientProvider);

    if (dappClientAsync is! AsyncData || dappClientAsync.value == null) {
      return Future.error('Wallet connection not ready or null');
    }

    await dappClientAsync.value!.close();
  }

  Future<void> update(FutureOr<Session> Function(Session previous) func) async {
    state = await func(state);
  }
}
