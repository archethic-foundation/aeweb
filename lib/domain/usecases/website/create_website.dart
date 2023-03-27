import 'dart:developer';

import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
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
    final files =
        await listFilesFromPath(path, applyGitIgnoreRules: applyGitIgnoreRules);
    if (files == null) {
      log('Unable to get the list of files');
      return;
    }

    log('Create files transactions');
    final contents = setContents(path, files.keys.toList());
    var transactionsList = <Transaction>[];
    for (final content in contents) {
      transactionsList.add(
        newTransactionFile(content),
      );
    }

    log('Sign ${transactionsList.length} files transactions');
    final keychainWebsiteService = 'aeweb-$websiteName';
    transactionsList = await signTx(
      keychainWebsiteService,
      'aeweb_files',
      transactionsList,
    );

    final filesWithAddress = setAddressesInTxRef(transactionsList, files);

    log('Create transaction reference');
    var transactionReference = newTransactionReference(filesWithAddress);

    log('Sign transaction reference');
    transactionReference = (await signTx(
      keychainWebsiteService,
      'aeweb_ref',
      [transactionReference],
    ))
        .first;

    log('Fees calculation');
    var feesFiles = 0.0;
    for (var i = 0; i < transactionsList.length; i++) {
      feesFiles = feesFiles + await calculateFees(transactionsList[i]);
    }

    final feesRef = await calculateFees(transactionReference);

    log('Create transfer transaction fo manage fees');
    final addressTxRef =
        await getDeriveAddress(keychainWebsiteService, 'aeweb_ref');
    final addressTxFiles =
        await getDeriveAddress(keychainWebsiteService, 'aeweb_files');
    var transactionTransfer =
        Transaction(type: 'transfer', data: Transaction.initData())
            .addUCOTransfer(addressTxRef, toBigInt(feesRef));
    if (feesFiles > 0) {
      transactionTransfer.addUCOTransfer(addressTxFiles, toBigInt(feesFiles));
    }

    final currentNameAccount = await getCurrentAccount();
    log('Sign transaction transfer');

    transactionTransfer = (await signTx(
      'archethic-wallet-$currentNameAccount',
      '',
      [transactionTransfer],
    ))
        .first;

    final feesTrf = await calculateFees(transactionTransfer);

    log('Global fees : ${feesFiles + feesTrf + feesRef} UCO');

    var transactionRepository = ArchethicTransactionSender(
      phoenixHttpEndpoint: '${sl.get<ApiService>().endpoint}/socket/websocket',
      websocketEndpoint:
          '${sl.get<ApiService>().endpoint.replaceAll('https:', 'ws:').replaceAll('http:', 'ws:')}/socket/websocket',
    );

    transactionRepository.send(
      transaction: transactionTransfer,
      onConfirmation: (confirmation) async {
        log('nbConfirmations: ${confirmation.nbConfirmations}, transactionAddress: ${confirmation.transactionAddress}, maxConfirmations: ${confirmation.maxConfirmations}');
        transactionRepository.close();
        final allTransactions = <Transaction>[
          transactionReference,
          ...transactionsList
        ];

        for (final transaction in allTransactions) {
          log('Send ${transaction.address!.address}');
          transactionRepository = ArchethicTransactionSender(
            phoenixHttpEndpoint:
                '${sl.get<ApiService>().endpoint}/socket/websocket',
            websocketEndpoint:
                '${sl.get<ApiService>().endpoint.replaceAll('https:', 'ws:').replaceAll('http:', 'ws:')}/socket/websocket',
          )..send(
              transaction: transaction,
              onConfirmation: (confirmation) async {
                log('nbConfirmations: ${confirmation.nbConfirmations}, transactionAddress: ${confirmation.transactionAddress}, maxConfirmations: ${confirmation.maxConfirmations}');
                transactionRepository.close();
              },
              onError: (error) async {
                transactionRepository.close();
                error.maybeMap(
                  connectivity: (_) {
                    log('no connection');
                  },
                  consensusNotReached: (_) {
                    log('consensus not reached');
                  },
                  timeout: (_) {
                    log('timeout');
                  },
                  invalidConfirmation: (_) {
                    log('invalid Confirmation');
                  },
                  other: (error) {
                    log('error');
                  },
                  orElse: () {
                    log('other');
                  },
                );
              },
            );
        }
      },
      onError: (error) async {
        error.maybeMap(
          connectivity: (_) {
            log('no connection');
          },
          consensusNotReached: (_) {
            log('consensus not reached');
          },
          timeout: (_) {
            log('timeout');
          },
          invalidConfirmation: (_) {
            log('invalid Confirmation');
          },
          other: (error) {
            log('error');
          },
          orElse: () {
            log('other');
          },
        );
      },
    );

    log('Website is deployed at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef');
  }
}
