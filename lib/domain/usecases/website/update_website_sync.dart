/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncUseCases with FileMixin, TransactionMixin {
  Future<void> run(
    WidgetRef ref,
    BuildContext context,
  ) async {
    final updateWebsiteSyncNotifier =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFeesUCO(0)
          ..setGlobalFeesValidated(null);

    final keychainWebsiteService = Uri.encodeFull(
      'aeweb-${ref.read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm).name}',
    );

    log('Get last transaction reference');
    updateWebsiteSyncNotifier.setStep(1);

    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');

    final lastTransactionReferenceMap =
        await sl.get<ApiService>().getLastTransaction(
      [addressTxRef],
      request:
          'data { content,  ownerships {  authorizedPublicKeys { encryptedSecretKey, publicKey } secret } }',
    );
    final lastTransactionReference = lastTransactionReferenceMap[addressTxRef];
    if (lastTransactionReference == null) {
      updateWebsiteSyncNotifier.setStepError(
        AppLocalizations.of(context)!.updateWebsiteSyncStepErrorGetLastRef,
      );
      log('Unable to get the last transaction reference');
      return;
    }

    final lastHostingTransactionReference = HostingRef.fromJson(
      jsonDecode(lastTransactionReference.data!.content!),
    );

    updateWebsiteSyncNotifier.setStep(2);

    final newMetaData = <String, HostingRefContentMetaData>{};
    final filesNewOrUpdated = <String>[];
    var refChanged = false;
    for (final comparedFile in ref
        .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
        .comparedFiles) {
      switch (comparedFile.status) {
        case HostingContentComparisonStatus.remoteOnly:
          refChanged = true;
          break;
        case HostingContentComparisonStatus.sameContent:
          final localFile = ref
              .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
              .localFiles[comparedFile.path];
          if (localFile != null) {
            newMetaData[comparedFile.path] = HostingRefContentMetaData(
              hash: localFile.hash,
              encoding: localFile.encoding,
              size: localFile.size,
            );
          }
          break;
        case HostingContentComparisonStatus.localOnly:
        case HostingContentComparisonStatus.differentContent:
          final localFile = ref
              .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
              .localFiles[comparedFile.path];
          if (localFile != null) {
            newMetaData[comparedFile.path] = HostingRefContentMetaData(
              hash: localFile.hash,
              encoding: localFile.encoding,
              size: localFile.size,
            );
          }
          filesNewOrUpdated.add(comparedFile.path);
          refChanged = true;
          break;
      }
    }

    if (refChanged == false) {
      updateWebsiteSyncNotifier
        ..setStep(1)
        ..setStepError(
          AppLocalizations.of(context)!.updateWebSiteNoUpdateNecessary,
        );
      return;
    }

    log('Create files transactions');
    updateWebsiteSyncNotifier.setStep(3);
    late final List<Map<String, dynamic>> contents;
    if (kIsWeb) {
      contents = setContentsFromZip(
        ref.read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm).zipFile!,
        filesNewOrUpdated,
      );
    } else {
      contents = setContentsFromPath(
        ref.read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm).path,
        filesNewOrUpdated,
      );
    }

    log('Nb of files transaction: ${contents.length}');
    if (contents.length > 1 && FeatureFlags.websiteSizeLimit) {
      updateWebsiteSyncNotifier.setStepError(
        AppLocalizations.of(context)!.updateWebsiteTooManyFiles,
      );
      return;
    }

    var transactionsList = <Transaction>[];
    for (final content in contents) {
      transactionsList.add(
        newTransactionFile(content),
      );
    }
    if (transactionsList.isNotEmpty) {
      log('Sign ${transactionsList.length} files transactions');
      updateWebsiteSyncNotifier.setStep(4);
      try {
        transactionsList = await signTx(
          keychainWebsiteService,
          'files',
          transactionsList,
        );
      } catch (e) {
        updateWebsiteSyncNotifier.setStepError((e as Failure).message!);
        log('Signature failed');
        return;
      }
    }

    final filesWithAddressNew =
        setAddressesInTxRef(transactionsList, newMetaData);

    final filesWithAddressWithLast = <String, HostingRefContentMetaData>{};
    filesWithAddressNew.forEach((key, value) {
      if (value.addresses.isEmpty) {
        if (newMetaData[key] != null &&
            lastHostingTransactionReference.metaData[key] != null) {
          filesWithAddressWithLast[key] = HostingRefContentMetaData(
            addresses: lastHostingTransactionReference.metaData[key]!.addresses,
            encoding: lastHostingTransactionReference.metaData[key]!.encoding,
            hash: lastHostingTransactionReference.metaData[key]!.hash,
            size: lastHostingTransactionReference.metaData[key]!.size,
          );
        }
      } else {
        filesWithAddressWithLast[key] = HostingRefContentMetaData(
          addresses: value.addresses,
          encoding: value.encoding,
          hash: value.hash,
          size: value.size,
        );
      }
    });

    log('Create transaction reference');
    updateWebsiteSyncNotifier.setStep(5);

    var transactionReference = await newTransactionReference(
      filesWithAddressWithLast,
      cert: Uint8List.fromList(
        utf8.encode(
          lastHostingTransactionReference.sslCertificate,
        ),
      ),
    );
    if (lastTransactionReference.data != null &&
        lastTransactionReference.data!.ownerships.length > 1 &&
        lastTransactionReference.data!.ownerships[0].secret != null) {
      transactionReference.addOwnership(
        lastTransactionReference.data!.ownerships[0].secret!,
        lastTransactionReference.data!.ownerships[0].authorizedPublicKeys,
      );
    }

    log('Sign transaction reference');
    updateWebsiteSyncNotifier.setStep(6);
    try {
      transactionReference = (await signTx(
        keychainWebsiteService,
        '',
        [transactionReference],
      ))
          .first;
    } catch (e) {
      updateWebsiteSyncNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    log('Fees calculation');
    updateWebsiteSyncNotifier.setStep(7);
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

    updateWebsiteSyncNotifier.setStep(8);

    log('Create transfer transaction to manage fees');

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

    updateWebsiteSyncNotifier.setStep(9);

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
      updateWebsiteSyncNotifier.setStepError((e as Failure).message!);
      log('Signature failed');
      return;
    }

    updateWebsiteSyncNotifier.setStep(10);
    final feesTrf = await calculateFees(transactionTransfer);
    log('feesTrf: $feesTrf');

    await updateWebsiteSyncNotifier
        .setGlobalFeesUCO(feesFiles + feesTrf + feesRef);
    log('Global fees : ${feesFiles + feesTrf + feesRef} UCO');

    updateWebsiteSyncNotifier.setStep(11);
    final startTime = DateTime.now();
    var timeout = false;
    while (ref
            .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
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
            .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
            .globalFeesValidated ==
        null) {
      updateWebsiteSyncNotifier.setStepError(
        AppLocalizations.of(context)!.updateWebsiteSyncStepErrorFeesTimeout,
      );
      return;
    }

    if (ref
            .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
            .globalFeesValidated ==
        false) {
      updateWebsiteSyncNotifier.setStepError(
        AppLocalizations.of(context)!.updateWebsiteSyncStepErrorFeesUnvalidated,
      );
      return;
    }

    updateWebsiteSyncNotifier.setStep(12);

    try {
      await sendTransactions(
        <Transaction>[
          transactionTransfer,
          ...transactionsList,
          transactionReference
        ],
      );

      if (ref
          .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
          .stepError
          .isEmpty) {
        updateWebsiteSyncNotifier.setStep(13);
        log("Website's update is deployed at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef");
      }
    } catch (e) {
      updateWebsiteSyncNotifier
        ..setStep(14)
        ..setStepError(e.toString().replaceAll('Exception: ', '').trim());
    }
  }
}
