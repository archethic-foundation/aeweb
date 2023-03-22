/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<ArchethicDAppClient>(
    () => ArchethicDAppClient.auto(
      origin: const RequestOrigin(
        name: 'aeweb',
      ),
      replyBaseUrl: 'aeweb://archethic.tech',
    ),
  );

  final endpointResponse = await sl.get<ArchethicDAppClient>().getEndpoint();
  var endpointUrl = '';
  endpointResponse.when(
    failure: (failure) {},
    success: (result) {
      endpointUrl = result.endpointUrl;
      sl.registerLazySingleton<ApiService>(() => ApiService(endpointUrl));
    },
  );
}
