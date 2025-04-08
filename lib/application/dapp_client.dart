import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapp_client.g.dart';

@riverpod
Future<awc.ArchethicDAppClient> dappClient(Ref ref) async {
  final client = await awc.ArchethicDAppClient.auto(
    origin: const awc.RequestOrigin(name: 'aeHosting'),
    replyBaseUrl: '',
    authorizedMethods: [
      awc.ArchethicDAppTransportMethods.webBrowserExtension,
      awc.ArchethicDAppTransportMethods.websocket,
      awc.ArchethicDAppTransportMethods.messageChannel,
    ],
  );
  ref.onDispose(client.close);

  return client;
}
