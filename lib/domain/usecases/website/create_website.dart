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
          transactionsList[i]
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

    final transactionReference = newTransactionReference(filesWithAddress);

    log('Sign transaction reference');
    final resultSignRef = await sl.get<ArchethicDAppClient>().signTransactions({
      'serviceName': keychainWebsiteService,
      'pathSuffix': 'aeweb_ref',
      'transactions': transactionReference.toJson(),
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
        // Fees estimation
        log('fees.....');
      },
    );
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
