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
      final Map<String, dynamic> contentMap =
          jsonDecode(transactionSigned.data!.content!);

      contentMap['content'].forEach((key, value) {
        if (transactionSigned.address != null) {
          addressesInTxRef.update(
            key,
            (existingValue) => List.from(existingValue)
              ..add(transactionSigned.address!.address!),
            ifAbsent: () => [transactionSigned.address!.address!],
          );
        }
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
