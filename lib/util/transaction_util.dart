import 'dart:convert';

import 'package:archethic_lib_dart/archethic_lib_dart.dart';

mixin TransactionMixin {
  Transaction newTransactionReference(
    Map<String, HostingContentMetaData> metaData,
  ) {
    final hosting =
        Hosting(aewebVersion: 1, hashFunction: 'sha1', metaData: metaData);
    return Transaction(type: 'hosting', data: Transaction.initData())
        .setContent(jsonEncode(hosting));
  }
}
