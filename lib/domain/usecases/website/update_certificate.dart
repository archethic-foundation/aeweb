/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/util/transaction_aeweb_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateUseCases with TransactionAEWebMixin {
  Future<void> run(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final updateCertificateNotifier =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFeesUCO(0)
          ..setGlobalFeesValidated(null);

    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(UpdateCertificateFormProvider.updateCertificateForm).name}',
    );

    log('Get last transaction reference');
    updateCertificateNotifier.setStep(1);

    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');

    final lastTransactionReferenceMap =
        await aedappfm.sl.get<ApiService>().getLastTransaction(
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

    final lastHostingTransactionReference = HostingRef.fromJson(
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
      sslKey: privateKey,
      cert: publicCert,
    );

    log('Sign transaction reference');
    updateCertificateNotifier.setStep(3);
    try {
      transactionReference = (await signTx(
        keychainWebsiteService,
        '',
        [transactionReference],
      ))
          .first;
    } catch (e) {
      updateCertificateNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    log('Fees calculation');
    updateCertificateNotifier.setStep(4);

    final feesRef = await calculateFees(transactionReference);
    log('feesRef: $feesRef');

    updateCertificateNotifier.setStep(5);

    log('Create transfer transaction to manage fees');

    final addressTxFiles =
        await getDeriveAddress(keychainWebsiteService, 'files');
    log('keychainWebsiteService: $keychainWebsiteService');
    log('addressTxRef: $addressTxRef');
    log('addressTxFiles: $addressTxFiles');
    final blockchainTxVersion = int.parse(
      (await aedappfm.sl.get<ApiService>().getBlockchainVersion())
          .version
          .transaction,
    );
    var transactionTransfer = Transaction(
      type: 'transfer',
      version: blockchainTxVersion,
      data: Transaction.initData(),
    ).addUCOTransfer(addressTxRef, toBigInt(feesRef));

    updateCertificateNotifier.setStep(6);

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
      updateCertificateNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    updateCertificateNotifier.setStep(7);
    final feesTrf = await calculateFees(transactionTransfer);
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
        <Transaction>[transactionTransfer, transactionReference],
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
        ..setStepError(e.toString().replaceAll('Exception: ', '').trim());
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
