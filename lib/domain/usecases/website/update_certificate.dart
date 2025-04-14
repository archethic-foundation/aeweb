/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/application/blockchain_tx_version.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/util/string_util.dart';
import 'package:aeweb/util/transaction_aeweb_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateUseCase
    with TransactionAEWebMixin, aedappfm.TransactionMixin {
  UpdateCertificateUseCase({
    required this.apiService,
    required this.dappClient,
  });

  final awc.ArchethicDAppClient dappClient;
  final archethic.ApiService apiService;

  Future<void> run(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final updateCertificateNotifier =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFeesValidated(null);

    final blockchainTxVersion =
        await ref.read(blockchainTxCurrentVersionProvider.future);

    await updateCertificateNotifier.setGlobalFeesUCO(0);

    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(UpdateCertificateFormProvider.updateCertificateForm).name}',
    );

    log('Get last transaction reference');
    updateCertificateNotifier.setStep(1);

    final addressTxRef =
        await getDeriveAddress(dappClient, keychainWebsiteService, '');

    final lastTransactionReferenceMap = await apiService.getLastTransaction(
      [addressTxRef],
      request:
          'data { content,  ownerships {  authorizedPublicKeys { encryptedSecretKey, publicKey } secret } }',
    );
    final lastTransactionReference = lastTransactionReferenceMap[addressTxRef];
    if (lastTransactionReference == null) {
      updateCertificateNotifier.setStepError(
        AppLocalizations.of(context)!.updateCertificateStepErrorGetLastRef,
      );
      log('Unable to get the last transaction reference');
      return;
    }

    final lastHostingTransactionReference = archethic.HostingRef.fromJson(
      jsonDecode(lastTransactionReference.data!.content!),
    );

    log('Create transaction reference');
    updateCertificateNotifier.setStep(2);
    final privateKey = ref
        .read(UpdateCertificateFormProvider.updateCertificateForm)
        .privateKey;
    final publicCert = ref
        .read(UpdateCertificateFormProvider.updateCertificateForm)
        .publicCert;
    var transactionReference = await newTransactionReference(
      lastHostingTransactionReference.metaData,
      apiService,
      blockchainTxVersion,
      sslKey: privateKey,
      cert: publicCert,
    );

    log('Sign transaction reference');
    updateCertificateNotifier.setStep(3);
    try {
      transactionReference = (await signTx(
        dappClient,
        keychainWebsiteService,
        '',
        [transactionReference],
      ))
          .first;
    } catch (e) {
      updateCertificateNotifier.setStepError(
        (e as aedappfm.Failure)
                .toString()
                .replaceAll('Exception: ', '')
                .capitalize() ??
            e.toString(),
      );
      log('Signature failed');
      return;
    }

    log('Fees calculation');
    updateCertificateNotifier.setStep(4);

    final feesRef = await calculateFees(
      transactionReference,
      apiService,
    );
    log('feesRef: $feesRef');

    updateCertificateNotifier.setStep(5);

    log('Create transfer transaction to manage fees');

    final addressTxFiles =
        await getDeriveAddress(dappClient, keychainWebsiteService, 'files');
    log('keychainWebsiteService: $keychainWebsiteService');
    log('addressTxRef: $addressTxRef');
    log('addressTxFiles: $addressTxFiles');

    var transactionTransfer = archethic.Transaction(
      type: 'transfer',
      version: blockchainTxVersion,
      data: archethic.Transaction.initData(),
    ).addUCOTransfer(addressTxRef, archethic.toBigInt(feesRef));

    updateCertificateNotifier.setStep(6);

    final currentNameAccount = await getCurrentAccount(dappClient);
    log('Sign transaction transfer');
    try {
      transactionTransfer = (await signTx(
        dappClient,
        Uri.encodeFull('archethic-wallet-$currentNameAccount'),
        '',
        [transactionTransfer],
      ))
          .first;
    } catch (e) {
      updateCertificateNotifier.setStepError(
        (e as aedappfm.Failure)
                .toString()
                .replaceAll('Exception: ', '')
                .capitalize() ??
            e.toString(),
      );
      log('Signature failed');
      return;
    }

    updateCertificateNotifier.setStep(7);
    final feesTrf = await calculateFees(
      transactionTransfer,
      apiService,
    );
    log('feesTrf: $feesTrf');

    await updateCertificateNotifier.setGlobalFeesUCO(feesTrf + feesRef);
    log('Global fees : ${feesTrf + feesRef} UCO');

    updateCertificateNotifier.setStep(8);
    final startTime = DateTime.now();
    var timeout = false;
    while (ref
            .read(UpdateCertificateFormProvider.updateCertificateForm)
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
            .read(UpdateCertificateFormProvider.updateCertificateForm)
            .globalFeesValidated ==
        null) {
      updateCertificateNotifier.setStepError(
        AppLocalizations.of(context)!.updateCertificateStepErrorFeesTimeout,
      );
      return;
    }

    if (ref
            .read(UpdateCertificateFormProvider.updateCertificateForm)
            .globalFeesValidated ==
        false) {
      updateCertificateNotifier.setStepError(
        AppLocalizations.of(context)!.updateCertificateStepErrorFeesUnvalidated,
      );
      return;
    }

    updateCertificateNotifier.setStep(9);

    try {
      await sendTransactions(
        <archethic.Transaction>[
          transactionTransfer,
          transactionReference,
        ],
        apiService,
      );

      if (ref
          .read(UpdateCertificateFormProvider.updateCertificateForm)
          .stepError
          .isEmpty) {
        updateCertificateNotifier.setStep(10);
      }
    } catch (e) {
      updateCertificateNotifier
        ..setStep(11)
        ..setStepError(
          (e as aedappfm.Failure)
                  .toString()
                  .replaceAll('Exception: ', '')
                  .capitalize() ??
              e.toString(),
        );
    }
  }

  String getStepLabel(
    BuildContext context,
    int step,
  ) {
    switch (step) {
      case 1:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep1;
      case 2:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep2;
      case 3:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep3;
      case 4:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep4;
      case 5:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep5;
      case 6:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep6;
      case 7:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep7;
      // case 8 = user needs to validate
      case 9:
        return AppLocalizations.of(context)!.updateCertificateWaitingStep9;
      case 10:
        return AppLocalizations.of(context)!.updateCertificateConfirmedStep10;
      default:
        return '';
    }
  }

  String getConfirmLabel(
    BuildContext context,
    int step,
  ) {
    switch (step) {
      case 3:
      case 6:
        return AppLocalizations.of(context)!.pleaseConfirmWallet;
    }
    return '';
  }
}
