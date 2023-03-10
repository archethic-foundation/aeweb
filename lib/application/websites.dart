/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/website.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websites.g.dart';

@riverpod
WebsitesRepository _websitesRepository(_WebsitesRepositoryRef ref) =>
    WebsitesRepository();

@riverpod
Future<List<Website>> _fetchWebsites(_FetchWebsitesRef ref) async {
  return ref.watch(_websitesRepositoryProvider).getWebsites();
}

class WebsitesRepository {
  Future<List<Website>> getWebsites() async {
    final services =
        await sl.get<ArchethicDAppClient>().getServicesFromKeychain();
    final websites = <Website>[];
    services.when(
      success: (success) {
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
            websites.add(
              Website(
                name: Uri.decodeFull(name),
                genesisAddress: '',
                globalFees: '',
                lastPublicationFees: '',
                nbTransactions: '',
                size: '',
              ),
            );
          }
        }
      },
      failure: (failure) => {},
    );
    return websites;
  }
}

abstract class WebsitesProviders {
  static final fetchWebsites = _fetchWebsitesProvider;
}
