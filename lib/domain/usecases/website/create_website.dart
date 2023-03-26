import 'dart:developer';

import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

class CreateWebsiteUseCases with FileMixin, TransactionMixin {
  Future<void> createWebsite(
    String websiteName,
    String path, {
    bool applyGitIgnoreRules = true,
  }) async {
    log('Create service in the keychain');

    final resultCreate = await createWebsiteServiceInKeychain(websiteName);
    if (resultCreate is Failure) {
      log('Transaction failed');
      return;
    }

    log('Get the list of files in the path');

    // Get the list of files in the path
    final files =
        await listFilesFromPath(path, applyGitIgnoreRules: applyGitIgnoreRules);
    if (files == null) {
      log('Unable to get the list of files');
      return;
    }

    log('Create files transactions');

    final contents = setContents(path, files.keys.toList());
    final transactionsList = <Transaction>[];
    for (final content in contents) {
      transactionsList.add(
        newTransactionFile(content),
      );
    }

    final keychainWebsiteService = 'aeweb-$websiteName';

    log('Sign ${transactionsList.length} files transactions');

    final resultSignFiles =
        await sl.get<ArchethicDAppClient>().signTransactions({
      'serviceName': keychainWebsiteService,
      'pathSuffix': 'aeweb_files',
      'transactions': List<dynamic>.from(
        transactionsList.map((Transaction x) => x.toJson()),
      ),
    });
    resultSignFiles.when(
      failure: (failure) {
        log(
          'Signature files failed',
          error: failure,
        );
        return;
      },
      success: (result) {
        log('Update ${transactionsList.length} files transactions');

        for (var i = 0; i < transactionsList.length; i++) {
          transactionsList[i] = transactionsList[i]
              .setAddress(Address(address: result.signedTxs[i].address))
              .setPreviousSignatureAndPreviousPublicKey(
                result.signedTxs[i].previousSignature,
                result.signedTxs[i].previousPublicKey,
              )
              .setOriginSignature(result.signedTxs[i].originSignature);
        }
      },
    );

    final filesWithAddress = setAddressesInTxRef(transactionsList, files);

    log('Create transaction reference');

    var transactionReference = newTransactionReference(filesWithAddress);

    log('Sign transaction reference');
    final resultSignRef = await sl.get<ArchethicDAppClient>().signTransactions({
      'serviceName': keychainWebsiteService,
      'pathSuffix': 'aeweb_ref',
      'transactions': [transactionReference.toJson()],
    });

    resultSignRef.when(
      failure: (failure) {
        log(
          'Signature ref failed',
          error: failure,
        );
        return;
      },
      success: (result) {
        transactionReference = transactionReference
            .setAddress(Address(address: result.signedTxs[0].address))
            .setPreviousSignatureAndPreviousPublicKey(
              result.signedTxs[0].previousSignature,
              result.signedTxs[0].previousPublicKey,
            )
            .setOriginSignature(result.signedTxs[0].originSignature);
      },
    );

    // Fees estimation
    log('Fees calculation');
    var feesRef = 0.0;
    var feesFiles = 0.0;
    var feesTrf = 0.0;
    const slippage = 1.01;
    for (var i = 0; i < transactionsList.length; i++) {
      try {
        final transactionFee =
            await sl.get<ApiService>().getTransactionFee(transactionsList[i]);
        feesFiles = feesFiles + transactionFee.fee! * slippage;
        log(
          'Transaction $i : ${fromBigInt(transactionFee.fee) * slippage} UCO',
        );
      } catch (e, stack) {
        log('Failed to get transaction fees', error: e, stackTrace: stack);
      }
    }

    var transactionFee =
        await sl.get<ApiService>().getTransactionFee(transactionReference);
    feesRef = transactionFee.fee! * slippage;
    log(
      'Transaction ref : ${fromBigInt(transactionFee.fee).toDouble() * slippage} UCO',
    );

    log('Create transfer transaction fo manage fees');

    var transactionTransfer =
        Transaction(type: 'transfer', data: Transaction.initData())
            .addUCOTransfer('', toBigInt(feesRef));

    if (feesFiles > 0) {
      transactionTransfer.addUCOTransfer('', toBigInt(feesFiles));
    }

    final resultSignTrf = await sl.get<ArchethicDAppClient>().signTransactions({
      'serviceName': keychainWebsiteService,
      'pathSuffix': '',
      'transactions': [transactionTransfer.toJson()],
    });
    resultSignTrf.when(
      failure: (failure) {
        log(
          'Signature trf failed',
          error: failure,
        );
        return;
      },
      success: (result) {
        transactionTransfer = transactionTransfer
            .setAddress(Address(address: result.signedTxs[0].address))
            .setPreviousSignatureAndPreviousPublicKey(
              result.signedTxs[0].previousSignature,
              result.signedTxs[0].previousPublicKey,
            )
            .setOriginSignature(result.signedTxs[0].originSignature);
      },
    );

    transactionFee =
        await sl.get<ApiService>().getTransactionFee(transactionTransfer);
    feesTrf = transactionFee.fee! * slippage;
    log(
      'Transaction trf : $feesTrf UCO',
    );

    log('Global fees : ${feesFiles + feesTrf + feesRef} UCO');
  }

  Future<dynamic> createWebsiteServiceInKeychain(String websiteName) async {
    final responseAddService = await sl
        .get<ArchethicDAppClient>()
        .addService({'name': 'aeweb-$websiteName'});
    responseAddService.when(
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
