import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/util/components/stepper/bloc/provider.dart';
import 'package:aeweb/util/confirmations/archethic_transaction_sender.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncUseCases with FileMixin, TransactionMixin {
  Future<void> updateWebsite(
    WidgetRef ref,
    String websiteName,
    String path,
    Map<String, HostingRefContentMetaData> localFiles,
    List<HostingContentComparison> comparedFiles,
  ) async {
    final aeStepperNotifier = ref.watch(AEStepperProvider.aeStepper.notifier);

    final keychainWebsiteService = Uri.encodeFull('aeweb-$websiteName');

    final addressTxRef = await getDeriveAddress(keychainWebsiteService, '');
    log('Get last transaction reference');
    aeStepperNotifier.setActiveIndex(3);
    final lastTransactionReferenceMap =
        await sl.get<ApiService>().getLastTransaction(
      [addressTxRef],
      request: 'data {content}',
    );
    final lastTransactionReference = lastTransactionReferenceMap[addressTxRef];
    if (lastTransactionReference == null) {
      log('Unable to get the last transaction reference');
      return;
    }
    final lastHostingTransactionReference = HostingRef.fromJson(
      jsonDecode(lastTransactionReference.data!.content!),
    );

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
      log('No update necessary');
      return;
    }

    aeStepperNotifier.setActiveIndex(1);

    log('Create files transactions');
    final contents = setContents(path, filesNewOrUpdated);
    var transactionsList = <Transaction>[];
    for (final content in contents) {
      transactionsList.add(
        newTransactionFile(content),
      );
    }

    log('Sign ${transactionsList.length} files transactions');
    aeStepperNotifier.setActiveIndex(2);

    transactionsList = await signTx(
      keychainWebsiteService,
      'files',
      transactionsList,
    );

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
    aeStepperNotifier.setActiveIndex(3);
    var transactionReference =
        newTransactionReference(filesWithAddressWithLast);

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
      log('previousPublicKey: ${transactionsList[i].previousPublicKey!}');

      final _fees = await calculateFees(transactionsList[i]);
      feesFiles = feesFiles + _fees;
      log('feesFiles: ${transactionsList[i].address} $feesFiles');
    }
    log('feesFiles: $feesFiles');

    final feesRef = await calculateFees(transactionReference);
    log('feesRef: $feesRef');

    log('Create transfer transaction to manage fees');
    aeStepperNotifier.setActiveIndex(6);

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
      Uri.encodeFull('archethic-wallet-$currentNameAccount'),
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
