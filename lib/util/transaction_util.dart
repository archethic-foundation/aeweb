import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

mixin TransactionMixin {
  Transaction newTransactionReference(
    Map<String, HostingRefContentMetaData> metaData,
  ) {
    final metaDataSorted = Map.fromEntries(
      metaData.entries.toList()
        ..sort(
          (e1, e2) => e1.key.compareTo(e2.key),
        ),
    );

    final hosting = HostingRef(
      aewebVersion: 1,
      hashFunction: 'sha1',
      metaData: metaDataSorted,
    );
    return Transaction(type: 'hosting', data: Transaction.initData())
        .setContent(jsonEncode(hosting));
  }

  Transaction newTransactionFile(
    Map<String, dynamic> txsContent,
  ) {
    final content = txsContent['content'];
    return Transaction(type: 'hosting', data: Transaction.initData())
        .setContent(jsonEncode(content));
  }

  Map<String, HostingRefContentMetaData> setAddressesInTxRef(
    List<Transaction> transactionsSigned,
    Map<String, HostingRefContentMetaData> metaData,
  ) {
    final addressesInTxRef = <String, List<String>>{};

    for (final transactionSigned in transactionsSigned) {
      jsonDecode(transactionSigned.data!.content!).forEach((key, value) {
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

  Future<List<Transaction>> signTx(
    String serviceName,
    String pathSuffix,
    List<Transaction> transactions,
  ) async {
    final newTransactions = <Transaction>[];

    log(
      {
        'serviceName': serviceName,
        'pathSuffix': pathSuffix,
        'transactions': List<dynamic>.from(
          transactions.map((Transaction x) => x.toJson()),
        ),
      }.toString(),
    );

    final result = await sl.get<ArchethicDAppClient>().signTransactions({
      'serviceName': serviceName,
      'pathSuffix': pathSuffix,
      'transactions': List<dynamic>.from(
        transactions.map((Transaction x) => x.toJson()),
      ),
    });
    result.when(
      failure: (failure) {
        log(
          'Signature failed',
          error: failure,
        );
        throw failure;
      },
      success: (result) {
        for (var i = 0; i < transactions.length; i++) {
          newTransactions.add(
            transactions[i]
                .setAddress(Address(address: result.signedTxs[i].address))
                .setPreviousSignatureAndPreviousPublicKey(
                  result.signedTxs[i].previousSignature,
                  result.signedTxs[i].previousPublicKey,
                )
                .setOriginSignature(result.signedTxs[i].originSignature),
          );
        }
      },
    );
    return newTransactions;
  }

  Future<double> calculateFees(Transaction transaction) async {
    const slippage = 2.01;
    final transactionFee =
        await sl.get<ApiService>().getTransactionFee(transaction);
    final fees = fromBigInt(transactionFee.fee) * slippage;
    log(
      'Transaction ${transaction.address} : $fees UCO',
    );
    return fees;
  }

  Future<String> getDeriveAddress(String serviceName, String pathSuffix) async {
    var address = '';
    (await sl.get<ArchethicDAppClient>().keychainDeriveAddress(
      {'serviceName': serviceName, 'pathSuffix': pathSuffix},
    ))
        .when(
      failure: (failure) {
        throw Exception('An error occurs');
      },
      success: (result) {
        address = result.address;
      },
    );
    return address;
  }

  Future<String> getCurrentAccount() async {
    var accountName = '';
    final result = await sl.get<ArchethicDAppClient>().getCurrentAccount();

    result.when(
      failure: (failure) {
        throw Exception('An error occurs');
      },
      success: (result) {
        accountName = result.name;
      },
    );
    return accountName;
  }

  Future<dynamic> createWebsiteServiceInKeychain(String websiteName) async {
    final responseAddService = await sl
        .get<ArchethicDAppClient>()
        .addService({'name': 'aeweb-$websiteName'});
    return responseAddService.when(
      failure: (failure) {
        log(
          'Transaction failed',
          error: failure,
        );
        return failure;
      },
      success: (result) {
        return result;
      },
    );
  }

  ArchethicTransactionSender getArchethicTransactionSender() {
    return ArchethicTransactionSender(
      phoenixHttpEndpoint: '${sl.get<ApiService>().endpoint}/socket/websocket',
      websocketEndpoint:
          '${sl.get<ApiService>().endpoint.replaceAll('https:', 'ws:').replaceAll('http:', 'ws:')}/socket/websocket',
    );
  }
}
