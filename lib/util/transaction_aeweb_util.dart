import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

mixin TransactionAEWebMixin {
  Future<Transaction> newTransactionReference(
    Map<String, HostingRefContentMetaData> metaData,
    ApiService apiService,
    int blockchainTxVersion, {
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

    final transaction = Transaction(
      type: 'hosting',
      // Interpreted SC // No WASM
      version: 3,
      data: Transaction.initData(),
    ).setContent(jsonEncode(hosting));

    if (sslKey != null) {
      final storageNoncePublicKey = await apiService.getStorageNoncePublicKey();
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

  Future<Transaction> newEmptyTransaction(
    int blockchainTxVersion,
  ) async {
    return Transaction(
      type: 'data',
      // Interpreted SC // No WASM
      version: 3,
      data: Transaction.initData(),
    ).setContent(
      jsonEncode(
        {
          'aeip': [8, 13],
          'aewebVersion': 1,
          'publicationStatus': 'UNPUBLISHED',
        },
      ),
    );
  }

  Future<Transaction> newTransactionFile(
    Map<String, dynamic> txsContent,
    int blockchainTxVersion,
  ) async {
    final content = txsContent['content'];
    return Transaction(
      type: 'hosting',
      // Interpreted SC // No WASM
      version: 3,
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

  Future<String> getDeriveAddress(
    awc.ArchethicDAppClient dappClient,
    String serviceName,
    String pathSuffix,
  ) async {
    var address = '';
    (await dappClient.keychainDeriveAddress(
      KeychainDeriveAddressRequest(
        serviceName: serviceName,
        pathSuffix: pathSuffix,
      ),
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

  Future<dynamic> createWebsiteServiceInKeychain(
    awc.ArchethicDAppClient dappClient,
    String websiteName,
  ) async {
    final responseAddService = await dappClient.addService(
      AddServiceRequest(name: 'aeweb-$websiteName'),
    );
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
}
