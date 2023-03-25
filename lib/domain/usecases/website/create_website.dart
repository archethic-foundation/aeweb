import 'dart:developer';

import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';

class CreateWebsiteUseCases with FileMixin, TransactionMixin {
  Future<void> createWebsite(
    String websiteName,
    String path, {
    bool applyGitIgnoreRules = true,
  }) async {
    // Create service in the keychain
    final result = await createWebsiteServiceInKeychain(websiteName);
    if (result is Failure) {
      log('Transaction failed');
      return;
    }

    // Get the list of files in the path
    final files =
        await listFilesFromPath(path, applyGitIgnoreRules: applyGitIgnoreRules);
    if (files == null) {
      log('Unable to get the list of files');
      return;
    }

    // Create files transaction

    // Create transaction reference
    final transactionReference = newTransactionReference(files);
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
