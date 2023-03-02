/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

void setupServiceLocator() {
  sl.registerLazySingleton<ArchethicDAppClient>(
    () => ArchethicDAppClient.auto(
      origin: const RequestOrigin(
        name: 'aeweb',
      ),
      replyBaseUrl: 'aeweb://archethic.tech',
    ),
  );
}
