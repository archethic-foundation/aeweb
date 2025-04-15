/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:developer';

import 'package:aeweb/application/blockchain_tx_version.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/util/string_util.dart';
import 'package:aeweb/util/transaction_aeweb_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnpublishWebsiteUseCase
    with TransactionAEWebMixin, aedappfm.TransactionMixin {
  UnpublishWebsiteUseCase({
    required this.apiService,
    required this.dappClient,
  });

  final awc.ArchethicDAppClient dappClient;
  final archethic.ApiService apiService;

  Future<void> run(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final unpublishWebsiteNotifier =
        ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFeesValidated(null);

    await unpublishWebsiteNotifier.setGlobalFeesUCO(0);

    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(UnpublishWebsiteFormProvider.unpublishWebsiteForm).name}',
    );

    log('Get last transaction reference');
    unpublishWebsiteNotifier.setStep(1);

    final addressTxRef =
        await getDeriveAddress(dappClient, keychainWebsiteService, '');

    final lastTransactionReferenceMap = await apiService.getLastTransaction(
      [addressTxRef],
      request: 'data {content}',
    );
    final lastTransactionReference = lastTransactionReferenceMap[addressTxRef];
    if (lastTransactionReference == null) {
      unpublishWebsiteNotifier.setStepError(
        AppLocalizations.of(context)!.unpublishWebsiteStepErrorGetLastRef,
      );
      log('Unable to get the last transaction reference');
      return;
    }

    log('Create empty transaction reference');
    unpublishWebsiteNotifier.setStep(2);

    final blockchainTxVersion =
        await ref.read(blockchainTxCurrentVersionProvider.future);

    var transactionReference = await newEmptyTransaction(blockchainTxVersion);

    log('Sign empty transaction reference');
    unpublishWebsiteNotifier.setStep(3);
    try {
      transactionReference = (await signTx(
        dappClient,
        keychainWebsiteService,
        '',
        [transactionReference],
      ))
          .first;
    } catch (e) {
      unpublishWebsiteNotifier.setStepError(
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
    unpublishWebsiteNotifier.setStep(4);

    final feesRef = await calculateFees(transactionReference, apiService);
    log('feesRef: $feesRef');

    unpublishWebsiteNotifier.setStep(5);

    log('Create transfer transaction to manage fees');

    log('keychainWebsiteService: $keychainWebsiteService');
    log('addressTxRef: $addressTxRef');

    var transactionTransfer = archethic.Transaction(
      type: 'transfer',
      // Interpreted SC // No WASM
      version: 3,
      data: archethic.Transaction.initData(),
    ).addUCOTransfer(addressTxRef, archethic.toBigInt(feesRef));

    unpublishWebsiteNotifier.setStep(6);

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
      unpublishWebsiteNotifier.setStepError(
        (e as aedappfm.Failure)
                .toString()
                .replaceAll('Exception: ', '')
                .capitalize() ??
            e.toString(),
      );
      log('Signature failed');
      return;
    }

    unpublishWebsiteNotifier.setStep(7);
    final feesTrf = await calculateFees(
      transactionTransfer,
      apiService,
    );
    log('feesTrf: $feesTrf');

    await unpublishWebsiteNotifier.setGlobalFeesUCO(feesTrf + feesRef);
    log('Global fees : ${feesTrf + feesRef} UCO');

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
        AppLocalizations.of(context)!.unpublishWebsiteStepErrorFeesTimeout,
      );

      return;
    }

    if (ref
            .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm)
            .globalFeesValidated ==
        false) {
      unpublishWebsiteNotifier.setStepError(
        AppLocalizations.of(context)!.unpublishWebsiteStepErrorFeesUnvalidated,
      );
      return;
    }

    unpublishWebsiteNotifier.setStep(9);

    try {
      await sendTransactions(
        <archethic.Transaction>[transactionTransfer, transactionReference],
        apiService,
      );

      if (ref
          .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm)
          .stepError
          .isEmpty) {
        unpublishWebsiteNotifier.setStep(10);
        log('The Website is unpublished at : ${apiService.endpoint}/aeweb/$addressTxRef');
      }
    } catch (e) {
      unpublishWebsiteNotifier
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
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep1;
      case 2:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep2;
      case 3:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep3;
      case 4:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep4;
      case 5:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep5;
      case 6:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep6;
      case 7:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep7;
      // case 8 = user needs to validate
      case 9:
        return AppLocalizations.of(context)!.unpublishWebSiteWaitingStep9;
      case 10:
        return AppLocalizations.of(context)!.unpublishWebSiteConfirmedStep10;
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
