import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

Future<void> setupServiceLocator() async {
  final archethicDAppClient = ArchethicDAppClient.auto(
    origin: const RequestOrigin(
      name: 'aeweb',
    ),
    replyBaseUrl: 'aeweb://archethic.tech',
  );

  sl.registerLazySingleton<ArchethicDAppClient>(
    () => archethicDAppClient,
  );
}

Future<void> setupServiceLocatorApiService(String endpoint) async {
  sl.registerLazySingleton<ApiService>(
    () => ApiService(endpoint),
  );
}
