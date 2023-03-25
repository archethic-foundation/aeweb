import 'dart:convert';
import 'dart:developer';

import 'package:archethic_lib_dart/archethic_lib_dart.dart';

mixin TransactionMixin {
  Transaction newTransactionReference(
    Map<String, HostingRefContentMetaData> metaData,
  ) {
    final hosting =
        HostingRef(aewebVersion: 1, hashFunction: 'sha1', metaData: metaData);
    return Transaction(type: 'hosting', data: Transaction.initData())
        .setContent(jsonEncode(hosting));
  }

  Transaction newTransactionFile(
    Map<String, dynamic> txsContent,
  ) {
    return Transaction(type: 'hosting', data: Transaction.initData())
        .setContent(jsonEncode(txsContent));
  }

  Map<String, HostingRefContentMetaData> setAddressesInTxRef(
    List<Transaction> transactionsSigned,
    Map<String, HostingRefContentMetaData> metaData,
  ) {
    var addressesInTxRef = <String, List<String>>{};

    for (final transactionSigned in transactionsSigned) {
      final Map<String, Map<String, String>> content =
          jsonDecode(transactionSigned.data!.content!);
      content['content']!.forEach((String key, String value) {
        addressesInTxRef[key] == null
            ? addressesInTxRef = {
                key: [value]
              }
            : addressesInTxRef[key]!.add(value);
      });
    }

    metaData.forEach((key, value) {
      final addresses = addressesInTxRef[key] ?? <String>[];
      final newValue = value.copyWith(
        addresses: addresses,
      );
      metaData[key] = newValue;
    });

    return metaData;
  }
}
