/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:developer';

import 'package:aeweb/application/main_screen_third_part.dart';
import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:aeweb/util/transaction_aeweb_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteUseCases
    with FileMixin, TransactionAEWebMixin, CertificateMixin {
  Future<void> run(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFeesUCO(0)
          ..setGlobalFeesValidated(null);

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

    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(AddWebsiteFormProvider.addWebsiteForm).name}',
    );
    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');
    await sl.get<DBHelper>().saveWebsite(
          Website(
            name: ref.read(AddWebsiteFormProvider.addWebsiteForm).name,
            genesisAddress: addressTxRef,
          ),
        );

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
      addWebsiteNotifier.setStepError(
        AppLocalizations.of(context)!.addWebsiteStepErrorGetListFiles,
      );
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
    final privateKey =
        ref.read(AddWebsiteFormProvider.addWebsiteForm).privateKey;
    final publicCert =
        ref.read(AddWebsiteFormProvider.addWebsiteForm).publicCert;
    var transactionReference = await newTransactionReference(
      filesWithAddress,
      sslKey: privateKey,
      cert: publicCert,
    );

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
      log('feesFiles: ${transactionsList[i].address} $_fees');
    }
    log('feesFiles: $feesFiles');

    final feesRef = await calculateFees(transactionReference);
    log('feesRef: $feesRef');

    log('Create transfer transaction to manage fees');
    addWebsiteNotifier.setStep(8);

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
    log('feesTrf: $feesTrf');

    await addWebsiteNotifier.setGlobalFeesUCO(feesFiles + feesTrf + feesRef);
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
        AppLocalizations.of(context)!.addWebsiteStepErrorFeesTimeout,
      );
      return;
    }

    if (ref.read(AddWebsiteFormProvider.addWebsiteForm).globalFeesValidated ==
        false) {
      addWebsiteNotifier.setStepError(
        AppLocalizations.of(context)!.addWebsiteStepErrorFeesUnvalidated,
      );
      return;
    }

    addWebsiteNotifier.setStep(12);
    try {
      await sendTransactions(
        <Transaction>[
          transactionTransfer,
          ...transactionsList,
          transactionReference,
        ],
      );

      if (ref.read(AddWebsiteFormProvider.addWebsiteForm).stepError.isEmpty) {
        addWebsiteNotifier.setStep(13);
        log('Website is deployed at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef');
        ref
            .read(SelectedWebsiteProviders.selectedWebsiteProvider.notifier)
            .setSelection(
              addressTxRef,
              ref.read(AddWebsiteFormProvider.addWebsiteForm).name,
            );
        ref
            .read(
              MainScreenThirdPartProviders.mainScreenThirdPartProvider.notifier,
            )
            .setWidget(const SizedBox());
      }
    } catch (e) {
      addWebsiteNotifier
        ..setStep(14)
        ..setStepError(e.toString().replaceAll('Exception: ', '').trim());
    }
  }
}
