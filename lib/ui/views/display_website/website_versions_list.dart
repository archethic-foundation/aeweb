import 'dart:math';

import 'package:aeweb/application/website_versions.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/model/website_version_tx.dart';
import 'package:aeweb/ui/views/display_website/explorer_files.dart';
import 'package:aeweb/ui/views/display_website/explorer_tx.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/unpublish_website_sheet.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/update_certificate_sheet.dart';
import 'package:aeweb/ui/views/util/certificate_infos_popup.dart';
import 'package:aeweb/ui/views/util/choose_path_sync_popup.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteVersionsList extends ConsumerWidget with FileMixin {
  const WebsiteVersionsList({
    super.key,
    required this.websiteName,
    required this.genesisAddress,
  });

  final String websiteName;
  final String genesisAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websiteVersionsList =
        ref.watch(WebsiteVersionProviders.fetchWebsiteVersions(genesisAddress));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: max(
            MediaQuery.of(context).size.width - 60,
            600,
          ), // 600 is the minimum width for the DataTable
          child: aedappfm.ArchethicScrollbar(
            child: websiteVersionsList.when(
              data: (websiteVersions) {
                final versions = websiteVersions.cast<WebsiteVersion>();
                if (versions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(aedappfm.Iconsax.warning_2),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsNoVersion,
                        ),
                      ],
                    ),
                  );
                }
                return DataTable(
                  horizontalMargin: 0,
                  dividerThickness: 1,
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsTableHeaderDate,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsTableHeaderFiles,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsTableHeaderSize,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsTableHeaderFees,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsTableHeaderCertificate,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsTableHeaderActions,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows: versions
                      .asMap()
                      .map(
                        (index, websiteVersion) => MapEntry(
                          index,
                          DataRow(
                            cells: [
                              DataCell(
                                SelectableText(
                                  DateFormat.yMd(
                                    Localizations.localeOf(context)
                                        .languageCode,
                                  ).add_Hms().format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          websiteVersion.timestamp * 1000,
                                        ).toLocal(),
                                      ),
                                ),
                              ),
                              DataCell(
                                Align(
                                  child: SelectableText(
                                    websiteVersion.filesCount == 0
                                        ? '-'
                                        : websiteVersion.filesCount.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Align(
                                  child: SelectableText(
                                    websiteVersion.size == 0
                                        ? '-'
                                        : filesize(
                                            websiteVersion.size.toString(),
                                          ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Align(
                                  child: SelectableText(
                                    '${fromBigInt(
                                      websiteVersion.fees,
                                    ).toStringAsPrecision(5)} UCO',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Align(
                                  child: websiteVersion.published
                                      ? websiteVersion.sslCertificate != null &&
                                              CertificateMixin.validCertificate(
                                                websiteVersion.sslCertificate!,
                                              )
                                          ? aedappfm.IconButtonAnimated(
                                              icon: const Icon(
                                                aedappfm.Iconsax.security_safe,
                                              ),
                                              onPressed: () {
                                                CertificateInfosPopup.getDialog(
                                                  context,
                                                  websiteVersion.sslCertificate,
                                                );
                                              },
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )
                                          : aedappfm.IconButtonAnimated(
                                              icon: const Icon(
                                                aedappfm.Iconsax.shield_slash,
                                              ),
                                              onPressed: () {
                                                CertificateInfosPopup.getDialog(
                                                  context,
                                                  websiteVersion.sslCertificate,
                                                );
                                              },
                                              color: Colors.red,
                                            )
                                      : const Text('-'),
                                ),
                              ),
                              DataCell(
                                Align(
                                  child: _popupMenuButton(
                                    context,
                                    ref,
                                    index == 0,
                                    websiteVersion,
                                    websiteName,
                                    genesisAddress,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .values
                      .toList(),
                );
              },
              error: (error, stacktrace) => const SizedBox(),
              loading: () => const Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 230,
                ),
                child: LinearProgressIndicator(
                  minHeight: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _popupMenuButton(
  BuildContext context,
  WidgetRef ref,
  bool lastVersion,
  WebsiteVersion websiteVersion,
  String websiteName,
  String genesisAddress,
) {
  return PopupMenuButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    itemBuilder: (context) {
      return [
        if (websiteVersion.published)
          PopupMenuItem(
            value: 'ExploreFiles',
            child: Row(
              children: [
                const Icon(aedappfm.Iconsax.folder_open),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!
                        .websitesListVersionsPopupExplore,
                  ),
                ),
              ],
            ),
          ),
        if (lastVersion)
          PopupMenuItem(
            value: 'VisitWebsite',
            child: Row(
              children: [
                const Icon(aedappfm.Iconsax.global),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!
                        .websitesListVersionsPopupBVisitWebsite,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  aedappfm.Iconsax.export_3,
                  size: 12,
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'ExploreTx',
          child: Row(
            children: [
              const Icon(aedappfm.Iconsax.receipt_text),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!
                      .websitesListVersionsPopupExploreTx,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'refTx',
          child: Row(
            children: [
              const Icon(aedappfm.Iconsax.archive_book),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.websitesListVersionsPopupRefTx,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                aedappfm.Iconsax.export_3,
                size: 12,
              ),
            ],
          ),
        ),
        if (lastVersion)
          PopupMenuItem(
            value: 'Sync',
            child: Row(
              children: [
                const Icon(aedappfm.Iconsax.refresh_circle),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.websitesListVersionsPopupSync,
                  ),
                ),
              ],
            ),
          ),
        if (lastVersion && websiteVersion.published)
          PopupMenuItem(
            value: 'ManageCert',
            child: Row(
              children: [
                const Icon(aedappfm.Iconsax.shield),
                const SizedBox(width: 8),
                Flexible(
                  child: websiteVersion.sslCertificate == null
                      ? Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsPopupAddCertif,
                        )
                      : Text(
                          AppLocalizations.of(context)!
                              .websitesListVersionsPopupUpdateCertif,
                        ),
                ),
              ],
            ),
          ),
        if (lastVersion && websiteVersion.published)
          PopupMenuItem(
            value: 'Unpublish',
            child: Row(
              children: [
                const Icon(aedappfm.Iconsax.folder_cross),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!
                        .websitesListVersionsPopupUnpublish,
                  ),
                ),
              ],
            ),
          ),
      ];
    },
    onSelected: (value) {
      switch (value) {
        case 'ExploreFiles':
          final filesAndFolders = websiteVersion.content!.metaData;

          context.go(
            ExplorerFilesScreen.routerPage,
            extra: {
              'filesAndFolders': filesAndFolders,
            },
          );
          break;

        case 'VisitWebsite':
          final url =
              '${aedappfm.sl.get<ApiService>().endpoint}/aeweb/$genesisAddress';
          launchUrl(
            Uri.parse(
              url,
            ),
          );
          break;
        case 'ExploreTx':
          final websiteVersionTxListAddresses = <String>{};
          if (websiteVersion.content != null) {
            websiteVersion.content!.metaData.forEach(
              (key, value) {
                for (final address in value.addresses) {
                  websiteVersionTxListAddresses.add(address);
                }
              },
            );
          }

          final websiteVersionTxList = <WebsiteVersionTx>[];
          websiteVersionTxList.add(
            WebsiteVersionTx(
              address: websiteVersion.transactionRefAddress,
              typeHostingTx: 'ref',
            ),
          );
          for (final websiteVersionTxListAddress
              in websiteVersionTxListAddresses) {
            websiteVersionTxList.add(
              WebsiteVersionTx(
                address: websiteVersionTxListAddress,
                typeHostingTx: 'files',
              ),
            );
          }
          context.go(
            ExplorerTxScreen.routerPage,
            extra: {'websiteVersionTxList': websiteVersionTxList},
          );

          break;
        case 'Sync':
          PathSyncPopup.getDialog(
            context,
            websiteVersion.transactionRefAddress,
            websiteName,
            genesisAddress,
          );
          break;
        case 'ManageCert':
          context.go(
            UpdateCertificateSheet.routerPage,
            extra: {'websiteName': websiteName},
          );
          break;
        case 'Unpublish':
          context.go(
            UnpublishWebsiteSheet.routerPage,
            extra: {'websiteName': websiteName},
          );
          break;
        case 'refTx':
          launchUrl(
            Uri.parse(
              '${aedappfm.sl.get<ApiService>().endpoint}/explorer/transaction/${websiteVersion.transactionRefAddress}',
            ),
          );
          break;
        default:
      }
    },
  );
}
