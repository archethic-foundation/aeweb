/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';

import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

class ReadWebsiteVersionUseCases {
  Future<WebsiteVersion?> getRemote(String transactionRefAddress) async {
    late WebsiteVersion websiteVersion;

    final transactionMap = await sl.get<ApiService>().getTransaction(
      [transactionRefAddress],
      request:
          'address, validationStamp { timestamp, ledgerOperations { fee } } data { content }',
    );
    final transaction = transactionMap[transactionRefAddress];
    if (transaction != null &&
        transaction.data != null &&
        transaction.data!.content != null) {
      var size = 0;
      final hosting = HostingRef.fromJson(
        jsonDecode(transaction.data!.content!),
      );

      hosting.metaData.forEach((key, value) {
        size = size + value.size;
      });

      websiteVersion = WebsiteVersion(
        transactionRefAddress: transaction.address!.address!,
        timestamp: transaction.validationStamp!.timestamp!,
        filesCount: hosting.metaData.length,
        size: size,
        fees: transaction.validationStamp!.ledgerOperations!.fee!,
        content: hosting,
      );
    }

    return websiteVersion;
  }
}
