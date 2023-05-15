import 'dart:async';
import 'dart:developer';

import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteUseCases with FileMixin, TransactionMixin, CertificateMixin {
  Future<void> run(
    WidgetRef ref,
  ) async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFees(0)
          ..setGlobalFeesValidated(null);

    // TODO(reddwarf03): Move to widget
    final publicCert =
        ref.read(AddWebsiteFormProvider.addWebsiteForm).publicCert;
    final privateKey =
        ref.read(AddWebsiteFormProvider.addWebsiteForm).privateKey;
    if (publicCert != null) {
      if (CertificateMixin.validCertificatFromFile(publicCert) == false) {
        addWebsiteNotifier.setStepError('SSL Certificate is invalid.');
        return;
      }
    }
    /*if (privateKey != null) {
      if (FileMixin.validCertificate(privateKey) == false) {
        addWebsiteNotifier.setStepError('SSL Key is invalid.');
        return;
      }
    }*/

    log('Create service in the keychain');
    addWebsiteNotifier.setStep(1);
    final resultCreate = await createWebsiteServiceInKeychain(
      ref.read(AddWebsiteFormProvider.addWebsiteForm).name,
    );
    if (resultCreate is Failure) {
      addWebsiteNotifier.setStepError(resultCreate.message!);
      log('Transaction failed');
      return;
    }

    log('Get the list of files in the path');
    addWebsiteNotifier.setStep(2);
    late final Map<String, HostingRefContentMetaData>? files;
    if (kIsWeb) {
      files = await FileMixin.listFilesFromZip(
        ref.read(AddWebsiteFormProvider.addWebsiteForm).zipFile!,
        applyGitIgnoreRules: ref
                .read(AddWebsiteFormProvider.addWebsiteForm)
                .applyGitIgnoreRules ??
            false,
      );
    } else {
      files = await FileMixin.listFilesFromPath(
        ref.read(AddWebsiteFormProvider.addWebsiteForm).path,
        applyGitIgnoreRules: ref
                .read(AddWebsiteFormProvider.addWebsiteForm)
                .applyGitIgnoreRules ??
            false,
      );
    }
    if (files == null) {
      addWebsiteNotifier.setStepError('Unable to get the list of files.');
      log('Unable to get the list of files');
      return;
    }

    log('Create files transactions');
    addWebsiteNotifier.setStep(3);
    late final List<Map<String, dynamic>> contents;
    if (kIsWeb) {
      contents = setContentsFromZip(
        ref.read(AddWebsiteFormProvider.addWebsiteForm).zipFile!,
        files.keys.toList(),
      );
    } else {
      contents = setContentsFromPath(
        ref.read(AddWebsiteFormProvider.addWebsiteForm).path,
        files.keys.toList(),
      );
    }

    var transactionsList = <Transaction>[];
    for (final content in contents) {
      transactionsList.add(
        newTransactionFile(content),
      );
    }

    log('Sign ${transactionsList.length} files transactions');
    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(AddWebsiteFormProvider.addWebsiteForm).name}',
    );
    addWebsiteNotifier.setStep(4);
    try {
      transactionsList = await signTx(
        keychainWebsiteService,
        'files',
        transactionsList,
      );
    } catch (e) {
      addWebsiteNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    final filesWithAddress = setAddressesInTxRef(transactionsList, files);

    log('Create transaction reference');
    addWebsiteNotifier.setStep(5);
    var transactionReference = newTransactionReference(filesWithAddress);

    log('Sign transaction reference');
    addWebsiteNotifier.setStep(6);

    try {
      transactionReference = (await signTx(
        keychainWebsiteService,
        '',
        [transactionReference],
      ))
          .first;
    } catch (e) {
      addWebsiteNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    log('Fees calculation');
    addWebsiteNotifier.setStep(7);
    var feesFiles = 0.0;
    for (var i = 0; i < transactionsList.length; i++) {
      log('previousPublicKey: ${transactionsList[i].previousPublicKey!}');

      final _fees = await calculateFees(transactionsList[i]);
      feesFiles = feesFiles + _fees;
      log('feesFiles: ${transactionsList[i].address} $feesFiles');
    }
    log('feesFiles: $feesFiles');

    final feesRef = await calculateFees(transactionReference);
    log('feesRef: $feesRef');

    log('Create transfer transaction to manage fees');
    addWebsiteNotifier.setStep(8);
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
    addWebsiteNotifier.setStep(9);
    try {
      transactionTransfer = (await signTx(
        Uri.encodeFull('archethic-wallet-$currentNameAccount'),
        '',
        [transactionTransfer],
      ))
          .first;
    } catch (e) {
      addWebsiteNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    addWebsiteNotifier.setStep(10);
    final feesTrf = await calculateFees(transactionTransfer);

    addWebsiteNotifier.setGlobalFees(feesFiles + feesTrf + feesRef);
    log('Global fees : ${feesFiles + feesTrf + feesRef} UCO');

    addWebsiteNotifier.setStep(11);
    final startTime = DateTime.now();
    var timeout = false;
    while (
        ref.read(AddWebsiteFormProvider.addWebsiteForm).globalFeesValidated ==
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

    if (ref.read(AddWebsiteFormProvider.addWebsiteForm).globalFeesValidated ==
        null) {
      addWebsiteNotifier.setStepError(
        "Le site web n'a pas été déployé car vous n'avez pas validé les frais à temps.",
      );
      return;
    }

    if (ref.read(AddWebsiteFormProvider.addWebsiteForm).globalFeesValidated ==
        false) {
      addWebsiteNotifier.setStepError(
        "Le site web n'a pas été déployé car les frais n'ont pas été validés.",
      );
      return;
    }

    var transactionRepository = ArchethicTransactionSender(
      phoenixHttpEndpoint: '${sl.get<ApiService>().endpoint}/socket/websocket',
      websocketEndpoint:
          '${sl.get<ApiService>().endpoint.replaceAll('https:', 'wss:').replaceAll('http:', 'wss:')}/socket/websocket',
    );

    addWebsiteNotifier.setStep(12);
    await transactionRepository.send(
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
                  addWebsiteNotifier.setStepError('No connection');
                  log('no connection');
                },
                consensusNotReached: (_) {
                  addWebsiteNotifier.setStepError('Consensus not reached');
                  log('consensus not reached');
                },
                timeout: (_) {
                  addWebsiteNotifier.setStepError('Timeout');
                  log('timeout');
                },
                invalidConfirmation: (_) {
                  addWebsiteNotifier.setStepError('Invalid Confirmation');
                  log('invalid Confirmation');
                },
                other: (error) {
                  addWebsiteNotifier.setStepError(error.message);
                  log('error');
                },
                orElse: () {
                  addWebsiteNotifier.setStepError('An error is occured');
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
            addWebsiteNotifier.setStepError('No connection');
            log('no connection');
          },
          consensusNotReached: (_) {
            addWebsiteNotifier.setStepError('Consensus not reached');
            log('consensus not reached');
          },
          timeout: (_) {
            addWebsiteNotifier.setStepError('Timeout');
            log('timeout');
          },
          invalidConfirmation: (_) {
            addWebsiteNotifier.setStepError('Invalid Confirmation');
            log('invalid Confirmation');
          },
          other: (error) {
            addWebsiteNotifier.setStepError(error.message);
            log('error');
          },
          orElse: () {
            addWebsiteNotifier.setStepError('An error is occured');
            log('other');
          },
        );
        return;
      },
    );

    if (ref.read(AddWebsiteFormProvider.addWebsiteForm).stepError.isEmpty) {
      addWebsiteNotifier.setStep(13);
      log('Website is deployed at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef');
    }
  }
}
