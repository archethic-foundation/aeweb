/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';

import 'package:aeweb/domain/repositories/website_versions.repository.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:basic_utils/basic_utils.dart';

class WebsiteVersionsRepositoryImpl implements WebsiteVersionsRepository {
  @override
  Future<List<WebsiteVersion>> getWebsiteVersions(String genesisAddress) async {
    final websiteVersions = <WebsiteVersion>[];

    var fees = 0;
    final transactionChainMap =
        await aedappfm.sl.get<ApiService>().getTransactionChain(
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

        final transactionsFeesMap =
            await aedappfm.sl.get<ApiService>().getTransaction(
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
