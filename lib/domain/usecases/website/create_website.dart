import 'dart:developer';

import 'package:aeweb/ui/views/util/components/stepper/bloc/provider.dart';
import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateWebsiteUseCases with FileMixin, TransactionMixin {
  Future<void> createWebsite(
    WidgetRef ref,
    String websiteName,
    String path, {
    bool applyGitIgnoreRules = true,
  }) async {
    final aeStepperNotifier = ref.watch(AEStepperProvider.aeStepper.notifier);

    log('Create service in the keychain');
    final resultCreate = await createWebsiteServiceInKeychain(websiteName);
    if (resultCreate is Failure) {
      log('Transaction failed');
      return;
    }

    aeStepperNotifier.setActiveIndex(1);
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
    aeStepperNotifier.setActiveIndex(2);
    final keychainWebsiteService = 'aeweb-$websiteName';
    transactionsList = await signTx(
      keychainWebsiteService,
      'files',
      transactionsList,
    );

    final filesWithAddress = setAddressesInTxRef(transactionsList, files);

    log('Create transaction reference');
    aeStepperNotifier.setActiveIndex(3);
    var transactionReference = newTransactionReference(filesWithAddress);

    log('Sign transaction reference');
    aeStepperNotifier.setActiveIndex(4);
    transactionReference = (await signTx(
      keychainWebsiteService,
      '',
      [transactionReference],
    ))
        .first;

    log('Fees calculation');
    aeStepperNotifier.setActiveIndex(5);
    var feesFiles = 0.0;
    for (var i = 0; i < transactionsList.length; i++) {
      log('previousPublicKey: ' + transactionsList[i].previousPublicKey!);

      final _fees = await calculateFees(transactionsList[i]);
      feesFiles = feesFiles + _fees;
      log('feesFiles: ${transactionsList[i].address} $feesFiles');
    }
    log('feesFiles: $feesFiles');

    final feesRef = await calculateFees(transactionReference);
    log('feesRef: $feesRef');

    log('Create transfer transaction to manage fees');
    aeStepperNotifier.setActiveIndex(6);
    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');
    final addressTxFiles =
        await getDeriveAddress(keychainWebsiteService, 'files');
    log('keychainWebsiteService: $keychainWebsiteService');
    log('addressTxRef: $addressTxRef');
    log('addressTxFiles: $addressTxFiles');
    var transactionTransfer =
        Transaction(type: 'transfer', data: Transaction.initData())
            .addUCOTransfer(addressTxRef, toBigInt(feesRef));
    if (feesFiles > 0) {
      transactionTransfer.addUCOTransfer(addressTxFiles, toBigInt(feesFiles));
    }

    final currentNameAccount = await getCurrentAccount();
    log('Sign transaction transfer');
    aeStepperNotifier.setActiveIndex(7);

    transactionTransfer = (await signTx(
      'archethic-wallet-$currentNameAccount',
      '',
      [transactionTransfer],
    ))
        .first;

    final feesTrf = await calculateFees(transactionTransfer);

    log('Global fees : ${feesFiles + feesTrf + feesRef} UCO');

    aeStepperNotifier.setActiveIndex(8);
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
          ...transactionsList,
          transactionReference
        ];

        for (final transaction in allTransactions) {
          log('Send ${transaction.address!.address}');
          transactionRepository = ArchethicTransactionSender(
            phoenixHttpEndpoint:
                '${sl.get<ApiService>().endpoint}/socket/websocket',
            websocketEndpoint:
                '${sl.get<ApiService>().endpoint.replaceAll('https:', 'ws:').replaceAll('http:', 'ws:')}/socket/websocket',
          );

          await transactionRepository.send(
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
    aeStepperNotifier.setActiveIndex(9);
    log('Website is deployed at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef');
  }
}
