import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

mixin TransactionAEWebMixin {
  Future<Transaction> newTransactionReference(
    Map<String, HostingRefContentMetaData> metaData, {
    Uint8List? sslKey,
    Uint8List? cert,
  }) async {
    final metaDataSorted = Map.fromEntries(
      metaData.entries.toList()
        ..sort(
          (e1, e2) => e1.key.compareTo(e2.key),
        ),
    );

    var hosting = HostingRef(
      metaData: metaDataSorted,
    );

    if (cert != null && cert.isNotEmpty) {
      hosting = hosting.copyWith(
        sslCertificate: utf8.decode(cert),
      );
    }
    final blockchainTxVersion = int.parse(
      (await sl.get<ApiService>().getBlockchainVersion()).version.transaction,
    );
    final transaction = Transaction(
      type: 'hosting',
      version: blockchainTxVersion,
      data: Transaction.initData(),
    ).setContent(jsonEncode(hosting));

    if (sslKey != null) {
      final storageNoncePublicKey =
          await sl.get<ApiService>().getStorageNoncePublicKey();
      final aesKey = uint8ListToHex(
        Uint8List.fromList(
          List<int>.generate(32, (int i) => math.Random.secure().nextInt(256)),
        ),
      );
      final encryptedSecretKey = ecEncrypt(aesKey, storageNoncePublicKey);
      final encryptedSslKey = aesEncrypt(sslKey, aesKey);
      final authorizedKey = AuthorizedKey(
        encryptedSecretKey: uint8ListToHex(encryptedSecretKey),
        publicKey: storageNoncePublicKey,
      );
      transaction
          .addOwnership(uint8ListToHex(encryptedSslKey), [authorizedKey]);
    }

    return transaction;
  }

  Future<Transaction> newEmptyTransaction() async {
    final blockchainTxVersion = int.parse(
      (await sl.get<ApiService>().getBlockchainVersion()).version.transaction,
    );
    return Transaction(
      type: 'data',
      version: blockchainTxVersion,
      data: Transaction.initData(),
    ).setContent('website unpublished');
  }

  Future<Transaction> newTransactionFile(
    Map<String, dynamic> txsContent,
  ) async {
    final blockchainTxVersion = int.parse(
      (await sl.get<ApiService>().getBlockchainVersion()).version.transaction,
    );
    final content = txsContent['content'];
    return Transaction(
      type: 'hosting',
      version: blockchainTxVersion,
      data: Transaction.initData(),
    ).setContent(jsonEncode(content));
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

    final payload = {
      'serviceName': serviceName,
      'pathSuffix': pathSuffix,
      'transactions': List<dynamic>.from(
        transactions.map((Transaction x) => x.toJson()),
      ),
    };
    log(
      payload.toString(),
    );

    final result =
        await sl.get<ArchethicDAppClient>().signTransactions(payload);
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
    const slippage = 1.01;
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
        accountName = result.shortName;
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
      apiService: sl.get<ApiService>(),
      phoenixHttpEndpoint: '${sl.get<ApiService>().endpoint}/socket/websocket',
      websocketEndpoint:
          '${sl.get<ApiService>().endpoint.replaceAll('https:', 'wss:').replaceAll('http:', 'wss:')}/socket/websocket',
    );
  }

  Future<void> sendTransactions(
    List<Transaction> transactions,
  ) async {
    var errorDetail = '';
    for (final transaction in transactions) {
      if (errorDetail.isNotEmpty) {
        break;
      }
      var next = false;
      String websocketEndpoint;
      switch (sl.get<ApiService>().endpoint) {
        case 'https://mainnet.archethic.net':
        case 'https://testnet.archethic.net':
          websocketEndpoint =
              "${sl.get<ApiService>().endpoint.replaceAll('https:', 'wss:').replaceAll('http:', 'wss:')}/socket/websocket";
          break;
        default:
          websocketEndpoint =
              "${sl.get<ApiService>().endpoint.replaceAll('https:', 'wss:').replaceAll('http:', 'ws:')}/socket/websocket";
          break;
      }

      final transactionRepository = ArchethicTransactionSender(
        apiService: sl.get<ApiService>(),
        phoenixHttpEndpoint:
            '${sl.get<ApiService>().endpoint}/socket/websocket',
        websocketEndpoint: websocketEndpoint,
      );
      log('Send ${transaction.address!.address}');

      await transactionRepository.send(
        transaction: transaction,
        onConfirmation: (confirmation) async {
          if (confirmation.isEnoughConfirmed) {
            log('nbConfirmations: ${confirmation.nbConfirmations}, transactionAddress: ${confirmation.transactionAddress}, maxConfirmations: ${confirmation.maxConfirmations}');
            transactionRepository.close();
            next = true;
          }
        },
        onError: (error) async {
          transactionRepository.close();
          error.maybeMap(
            connectivity: (_) {
              errorDetail = 'No connection';
            },
            consensusNotReached: (_) {
              errorDetail = 'Consensus not reached';
            },
            timeout: (_) {
              errorDetail = 'Timeout';
            },
            invalidConfirmation: (_) {
              errorDetail = 'Invalid Confirmation';
            },
            insufficientFunds: (_) {
              errorDetail = 'Insufficient funds';
            },
            other: (error) {
              errorDetail = error.message;
            },
            orElse: () {
              errorDetail = 'An error is occured';
            },
          );
        },
      );

      while (next == false && errorDetail.isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        log('wait...');
      }
    }

    if (errorDetail.isNotEmpty) {
      throw Exception(errorDetail);
    }
  }
}
