/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';

import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:basic_utils/basic_utils.dart';
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
    final websites = await sl.get<DBHelper>().getLocalWebsites();
    if (websites.isEmpty) {
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
              // Get genesis address
              final response =
                  await sl.get<ArchethicDAppClient>().keychainDeriveAddress({
                'serviceName': 'aeweb-$name',
                'index': 0,
                'pathSuffix': '',
              });
              response.when(
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

      await sl.get<DBHelper>().saveWebsites(websites);
    }

    return websites;
  }

  Future<List<WebsiteVersion>> getWebsiteVersions(String genesisAddress) async {
    final websiteVersions = <WebsiteVersion>[];

    var fees = 0;
    final transactionChainMap = await sl.get<ApiService>().getTransactionChain(
      {genesisAddress: ''},
      request:
          'type, address, validationStamp { timestamp, ledgerOperations { fee } } data { content , }',
      orderAsc: false,
    );

    final transactions = transactionChainMap[genesisAddress];
    for (final transaction in transactions!) {
      var size = 0;

      if (transaction.validationStamp != null &&
          transaction.validationStamp!.ledgerOperations != null &&
          transaction.validationStamp!.ledgerOperations!.fee != null) {
        fees = fees + transaction.validationStamp!.ledgerOperations!.fee!;
      }

      if (transaction.type == 'hosting') {
        final hosting = HostingRef.fromJson(
          jsonDecode(transaction.data!.content!),
        );

        final filesTxAddress = <String>{};
        hosting.metaData.forEach((key, value) {
          for (final address in value.addresses) {
            filesTxAddress.add(address);
          }
          size = size + value.size;
        });

        final transactionsFeesMap = await sl.get<ApiService>().getTransaction(
              filesTxAddress.toList(),
              request: 'validationStamp { ledgerOperations { fee } } ',
            );
        transactionsFeesMap.forEach((key, value) {
          if (value.validationStamp != null &&
              value.validationStamp!.ledgerOperations != null &&
              value.validationStamp!.ledgerOperations!.fee != null) {
            fees = fees + value.validationStamp!.ledgerOperations!.fee!;
          }
        });

        if (hosting.sslCertificate.isNotEmpty) {
          final x509Certificate =
              X509Utils.x509CertificateFromPem(hosting.sslCertificate);
          websiteVersions.add(
            WebsiteVersion(
              transactionRefAddress: transaction.address!.address!,
              timestamp: transaction.validationStamp!.timestamp!,
              filesCount: hosting.metaData.length,
              size: size,
              fees: fees,
              content: hosting,
              sslCertificate: x509Certificate,
            ),
          );
        } else {
          websiteVersions.add(
            WebsiteVersion(
              transactionRefAddress: transaction.address!.address!,
              timestamp: transaction.validationStamp!.timestamp!,
              filesCount: hosting.metaData.length,
              size: size,
              fees: fees,
              content: hosting,
            ),
          );
        }
      }

      if (transaction.type == 'data') {
        websiteVersions.add(
          WebsiteVersion(
            transactionRefAddress: transaction.address!.address!,
            timestamp: transaction.validationStamp!.timestamp!,
            fees: fees,
            published: false,
          ),
        );
      }
    }
    return websiteVersions;
  }
}

abstract class WebsitesProviders {
  static final fetchWebsites = _fetchWebsitesProvider;
  static const fetchWebsiteVersions = _fetchWebsiteVersionsProvider;
}
