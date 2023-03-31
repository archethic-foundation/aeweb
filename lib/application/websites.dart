/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/model/website.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
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

@riverpod
Future<List<WebsiteVersion>> _fetchWebsiteVersions(
  _FetchWebsiteVersionsRef ref,
  genesisAddress,
) async {
  return ref
      .watch(_websitesRepositoryProvider)
      .getWebsiteVersions(genesisAddress);
}

class WebsitesRepository {
  Future<List<Website>> getWebsites() async {
    final websites = <Website>[];
    final services =
        await sl.get<ArchethicDAppClient>().getServicesFromKeychain();

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
            var size = 0;
            final addresses = <String>[];
            HostingRef? hosting;
            // Get genesis address
            final response = await sl
                .get<ArchethicDAppClient>()
                .keychainDeriveAddress({
              'serviceName': 'aeweb-$name',
              'index': 0,
              'pathSuffix': ''
            });
            response.when(
              failure: (failure) {},
              success: (result) async {
                genesisAddress = result.address;

                // Last address
                final lastAddressMap =
                    await sl.get<ApiService>().getLastTransaction(
                  [genesisAddress],
                  request: 'address, data {content}',
                );
                if (lastAddressMap[genesisAddress] != null) {
                  log(lastAddressMap[genesisAddress]!.address.toString());

                  hosting = HostingRef.fromJson(
                    jsonDecode(lastAddressMap[genesisAddress]!.data!.content!),
                  );
                  if (hosting != null) {
                    hosting!.metaData.forEach((key, value) {
                      size = size + value.size;
                      addresses.addAll(value.addresses);
                    });
                  }
                }
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
    return websites;
  }

  Future<List<WebsiteVersion>> getWebsiteVersions(String genesisAddress) async {
    final websiteVersions = <WebsiteVersion>[];

    final transactionChainMap = await sl.get<ApiService>().getTransactionChain(
      {genesisAddress: ''},
      request: 'address, validationStamp { timestamp } data { content }',
      orderAsc: false,
    );

    final transactions = transactionChainMap[genesisAddress];
    for (final transaction in transactions!) {
      var size = 0;
      final hosting = HostingRef.fromJson(
        jsonDecode(transaction.data!.content!),
      );

      hosting.metaData.forEach((key, value) {
        size = size + value.size;
      });

      websiteVersions.add(
        WebsiteVersion(
          transactionRefAddress: transaction.address!.address!,
          timestamp: transaction.validationStamp!.timestamp!,
          filesCount: hosting.metaData.length,
          size: size,
          content: hosting,
        ),
      );
    }

    return websiteVersions;
  }
}

abstract class WebsitesProviders {
  static final fetchWebsites = _fetchWebsitesProvider;
  static final fetchWebsiteVersions = _fetchWebsiteVersionsProvider;
}
