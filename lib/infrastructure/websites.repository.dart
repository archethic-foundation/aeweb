import 'package:aeweb/domain/repositories/websites.repository.dart';
import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/model/website.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

class WebsitesRepositoryImpl implements WebsitesRepository {
  @override
  Future<List<Website>> getWebsites() async {
    final websites = await aedappfm.sl.get<DBHelper>().getLocalWebsites();
    if (websites.isEmpty) {
      final services = await aedappfm.sl
          .get<ArchethicDAppClient>()
          .getServicesFromKeychain();

      await services.when(
        success: (success) async {
          const kDerivationPathAEWebWithoutService = "m/650'/aeweb-";

          for (final service in success.services) {
            if (service.derivationPath
                .startsWith(kDerivationPathAEWebWithoutService)) {
              final path = service.derivationPath
                  .replaceAll(kDerivationPathAEWebWithoutService, '')
                  .split('/')
                ..last = '';
              var name = path.join('/');
              name = name.substring(0, name.length - 1);

              var genesisAddress = '';
              // Get genesis address
              final response = await aedappfm.sl
                  .get<ArchethicDAppClient>()
                  .keychainDeriveAddress({
                'serviceName': 'aeweb-$name',
                'index': 0,
                'pathSuffix': '',
              });
              await response.when(
                failure: (failure) {},
                success: (result) async {
                  genesisAddress = result.address;
                },
              );
              websites.add(
                Website(
                  name: Uri.decodeFull(name),
                  genesisAddress: genesisAddress,
                ),
              );
            }
          }
        },
        failure: (failure) async {
          return [];
        },
      );

      await aedappfm.sl.get<DBHelper>().saveWebsites(websites);
    }

    return websites;
  }
}
