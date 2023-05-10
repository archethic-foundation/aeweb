import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncUseCases with FileMixin, TransactionMixin {
  Future<void> run(
    WidgetRef ref,
    String websiteName,
    String path,
    Map<String, HostingRefContentMetaData> localFiles,
    List<HostingContentComparison> comparedFiles,
  ) async {
    final updateWebsiteSyncNotifier =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFees(0)
          ..setGlobalFeesValidated(null);

    final keychainWebsiteService = Uri.encodeFull('aeweb-$websiteName');

    log('Get last transaction reference');
    updateWebsiteSyncNotifier.setStep(1);

    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');

    final lastTransactionReferenceMap =
        await sl.get<ApiService>().getLastTransaction(
      [addressTxRef],
      request: 'data {content}',
    );
    final lastTransactionReference = lastTransactionReferenceMap[addressTxRef];
    if (lastTransactionReference == null) {
      updateWebsiteSyncNotifier
          .setStepError('Unable to get the last transaction reference');
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
    for (final comparedFile in comparedFiles) {
      switch (comparedFile.status) {
        case HostingContentComparisonStatus.remoteOnly:
          refChanged = true;
          break;
        case HostingContentComparisonStatus.sameContent:
          final localFile = localFiles[comparedFile.path];
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
          final localFile = localFiles[comparedFile.path];
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
      updateWebsiteSyncNotifier.setStepError('No update necessary');
      log('No update necessary');
      return;
    }

    log('Create files transactions');
    updateWebsiteSyncNotifier.setStep(3);
    final contents = setContents(path, filesNewOrUpdated);
    var transactionsList = <Transaction>[];
    for (final content in contents) {
      transactionsList.add(
        newTransactionFile(content),
      );
    }

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
    var transactionReference =
        newTransactionReference(filesWithAddressWithLast);

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
      log('feesFiles: ${transactionsList[i].address} $feesFiles');
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

    updateWebsiteSyncNotifier.setGlobalFees(feesFiles + feesTrf + feesRef);
    log('Global fees : ${feesFiles + feesTrf + feesRef} UCO');

    var transactionRepository = ArchethicTransactionSender(
      phoenixHttpEndpoint: '${sl.get<ApiService>().endpoint}/socket/websocket',
      websocketEndpoint:
          '${sl.get<ApiService>().endpoint.replaceAll('https:', 'ws:').replaceAll('http:', 'ws:')}/socket/websocket',
    );

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
        "La mise à jour du site web n'a pas été déployée car vous n'avez pas validé les frais à temps.",
      );
      return;
    }

    if (ref
            .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
            .globalFeesValidated ==
        false) {
      updateWebsiteSyncNotifier.setStepError(
        "La mise à jour du site web n'a pas été déployée car les frais n'ont pas été validés.",
      );
      return;
    }

    updateWebsiteSyncNotifier.setStep(12);
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
                  updateWebsiteSyncNotifier.setStepError('No connection');
                  log('no connection');
                },
                consensusNotReached: (_) {
                  updateWebsiteSyncNotifier
                      .setStepError('Consensus not reached');
                  log('consensus not reached');
                },
                timeout: (_) {
                  updateWebsiteSyncNotifier.setStepError('Timeout');
                  log('timeout');
                },
                invalidConfirmation: (_) {
                  updateWebsiteSyncNotifier
                      .setStepError('Invalid Confirmation');
                  log('invalid Confirmation');
                },
                other: (error) {
                  updateWebsiteSyncNotifier.setStepError(error.message);
                  log('error');
                },
                orElse: () {
                  updateWebsiteSyncNotifier.setStepError('An error is occured');
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
            updateWebsiteSyncNotifier.setStepError('No connection');
            log('no connection');
          },
          consensusNotReached: (_) {
            updateWebsiteSyncNotifier.setStepError('Consensus not reached');
            log('consensus not reached');
          },
          timeout: (_) {
            updateWebsiteSyncNotifier.setStepError('Timeout');
            log('timeout');
          },
          invalidConfirmation: (_) {
            updateWebsiteSyncNotifier.setStepError('Invalid Confirmation');
            log('invalid Confirmation');
          },
          other: (error) {
            updateWebsiteSyncNotifier.setStepError(error.message);
            log('error');
          },
          orElse: () {
            updateWebsiteSyncNotifier.setStepError('An error is occured');
            log('other');
          },
        );
        return;
      },
    );
    if (ref
        .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm)
        .stepError
        .isEmpty) {
      updateWebsiteSyncNotifier.setStep(13);
      log("Website's update is deployed at : ${sl.get<ApiService>().endpoint}/api/web_hosting/$addressTxRef");
    }
  }
}
