/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:developer';

import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnpublishWebsiteUseCases with TransactionMixin {
  Future<void> run(
    WidgetRef ref,
  ) async {
    final unpublishWebsiteNotifier =
        ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFees(0)
          ..setGlobalFeesValidated(null);

    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(UnpublishWebsiteFormProvider.unpublishWebsiteForm).name}',
    );

    log('Get last transaction reference');
    unpublishWebsiteNotifier.setStep(1);

    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');

    final lastTransactionReferenceMap =
        await sl.get<ApiService>().getLastTransaction(
      [addressTxRef],
      request: 'data {content}',
    );
    final lastTransactionReference = lastTransactionReferenceMap[addressTxRef];
    if (lastTransactionReference == null) {
      unpublishWebsiteNotifier
          .setStepError('Unable to get the last transaction reference');
      log('Unable to get the last transaction reference');
      return;
    }

    log('Create empty transaction reference');
    unpublishWebsiteNotifier.setStep(2);
    var transactionReference =
        newTransactionReference(<String, HostingRefContentMetaData>{});

    log('Sign transaction reference');
    unpublishWebsiteNotifier.setStep(3);
    try {
      transactionReference = (await signTx(
        keychainWebsiteService,
        '',
        [transactionReference],
      ))
          .first;
    } catch (e) {
      unpublishWebsiteNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    log('Fees calculation');
    unpublishWebsiteNotifier.setStep(4);

    final feesRef = await calculateFees(transactionReference);
    log('feesRef: $feesRef');

    unpublishWebsiteNotifier.setStep(5);

    log('Create transfer transaction to manage fees');

    log('keychainWebsiteService: $keychainWebsiteService');
    log('addressTxRef: $addressTxRef');
    var transactionTransfer =
        Transaction(type: 'transfer', data: Transaction.initData())
            .addUCOTransfer(addressTxRef, toBigInt(feesRef));

    unpublishWebsiteNotifier.setStep(6);

    final currentNameAccount = await getCurrentAccount();
    log('Sign transaction transfer');
    try {
      transactionTransfer = (await signTx(
        Uri.encodeFull('archethic-wallet-$currentNameAccount'),
        '',
        [transactionTransfer],
      ))
          .first;
    } catch (e) {
      unpublishWebsiteNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    unpublishWebsiteNotifier.setStep(7);
    final feesTrf = await calculateFees(transactionTransfer);

    unpublishWebsiteNotifier.setGlobalFees(feesTrf + feesRef);
    log('Global fees : ${feesTrf + feesRef} UCO');

    var transactionRepository = ArchethicTransactionSender(
      phoenixHttpEndpoint: '${sl.get<ApiService>().endpoint}/socket/websocket',
      websocketEndpoint:
          '${sl.get<ApiService>().endpoint.replaceAll('https:', 'wss:').replaceAll('http:', 'wss:')}/socket/websocket',
    );

    unpublishWebsiteNotifier.setStep(8);
    final startTime = DateTime.now();
    var timeout = false;
    while (ref
            .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm)
            .globalFeesValidated ==
        null) {
      if (DateTime.now().difference(startTime).inSeconds >= 60) {
        log('Timeout');
        timeout = true;
      }
      if (timeout) {
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    if (ref
            .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm)
            .globalFeesValidated ==
        null) {
      unpublishWebsiteNotifier.setStepError(
        "La mise à jour du site web n'a pas été déployée car vous n'avez pas validé les frais à temps.",
      );
      return;
    }

    if (ref
            .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm)
            .globalFeesValidated ==
        false) {
      unpublishWebsiteNotifier.setStepError(
        "La mise à jour du site web n'a pas été déployée car les frais n'ont pas été validés.",
      );
      return;
    }

    unpublishWebsiteNotifier.setStep(9);
    await transactionRepository.send(
      transaction: transactionTransfer,
      onConfirmation: (confirmation) async {
        log('nbConfirmations: ${confirmation.nbConfirmations}, transactionAddress: ${confirmation.transactionAddress}, maxConfirmations: ${confirmation.maxConfirmations}');
        transactionRepository.close();
        final allTransactions = <Transaction>[transactionReference];

        for (final transaction in allTransactions) {
          log('Send ${transaction.address!.address}');
          transactionRepository = ArchethicTransactionSender(
            phoenixHttpEndpoint:
                '${sl.get<ApiService>().endpoint}/socket/websocket',
            websocketEndpoint:
                '${sl.get<ApiService>().endpoint.replaceAll('https:', 'wss:').replaceAll('http:', 'wss:')}/socket/websocket',
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
                  unpublishWebsiteNotifier.setStepError('No connection');
                  log('no connection');
                },
                consensusNotReached: (_) {
                  unpublishWebsiteNotifier
                      .setStepError('Consensus not reached');
                  log('consensus not reached');
                },
                timeout: (_) {
                  unpublishWebsiteNotifier.setStepError('Timeout');
                  log('timeout');
                },
                invalidConfirmation: (_) {
                  unpublishWebsiteNotifier.setStepError('Invalid Confirmation');
                  log('invalid Confirmation');
                },
                other: (error) {
                  unpublishWebsiteNotifier.setStepError(error.message);
                  log('error');
                },
                orElse: () {
                  unpublishWebsiteNotifier.setStepError('An error is occured');
                  log('other');
                },
              );
              return;
            },
          );
        }
      },
      onError: (error) async {
        error.maybeMap(
          connectivity: (_) {
            unpublishWebsiteNotifier.setStepError('No connection');
            log('no connection');
          },
          consensusNotReached: (_) {
            unpublishWebsiteNotifier.setStepError('Consensus not reached');
            log('consensus not reached');
          },
          timeout: (_) {
            unpublishWebsiteNotifier.setStepError('Timeout');
            log('timeout');
          },
          invalidConfirmation: (_) {
            unpublishWebsiteNotifier.setStepError('Invalid Confirmation');
            log('invalid Confirmation');
          },
          other: (error) {
            unpublishWebsiteNotifier.setStepError(error.message);
            log('error');
          },
          orElse: () {
            unpublishWebsiteNotifier.setStepError('An error is occured');
            log('other');
          },
        );
        return;
      },
    );
    if (ref
        .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm)
        .stepError
        .isEmpty) {
      unpublishWebsiteNotifier.setStep(10);
      log('The Website is unpublished at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef');
    }
  }
}
