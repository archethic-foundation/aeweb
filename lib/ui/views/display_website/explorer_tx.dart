/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:math';
import 'dart:ui';

import 'package:aeweb/model/website_version_tx.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorerTxScreen extends ConsumerWidget {
  const ExplorerTxScreen({super.key, required this.websiteVersionTxList});

  final List<WebsiteVersionTx> websiteVersionTxList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AppBar(
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: ArchethicThemeBase.neutral0.withOpacity(0.2),
                    height: 1,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.explorerTxTitle,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const AEWebBackground(),
          if (websiteVersionTxList.isEmpty)
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(aedappfm.Iconsax.warning_2),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.websitesListVersionsNoVersion,
                  ),
                ],
              ),
            )
          else
            aedappfm.ArchethicScrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100),
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return DataTable(
                          horizontalMargin: 0,
                          dividerThickness: 1,
                          dataRowMaxHeight: 90,
                          columns: [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .explorerTxTableHeaderType,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .explorerTxTableHeaderAddress,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .explorerTxTableHeaderLink,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                          rows: websiteVersionTxList
                              .asMap()
                              .map(
                                (index, websiteVersionTx) => MapEntry(
                                  index,
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        Align(
                                          child: websiteVersionTx
                                                      .typeHostingTx ==
                                                  'ref'
                                              ? const Icon(
                                                  aedappfm.Iconsax.archive_book,
                                                )
                                              : const Icon(
                                                  aedappfm.Iconsax.document,
                                                ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              // we need to make that because the text is going to have no space and be very long so no overflow methods work :(
                                              maxWidth: min(
                                                600, // Standard transaction address take 600 in space
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    220, // Width - 220 (approximately the width of the other columns)
                                              ),
                                            ),
                                            child: SelectableText(
                                              websiteVersionTx.address
                                                  .toLowerCase(),
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          child: aedappfm.IconButtonAnimated(
                                            icon: const Icon(
                                              aedappfm.Iconsax.export_3,
                                            ),
                                            onPressed: () {
                                              launchUrl(
                                                Uri.parse(
                                                  '${aedappfm.sl.get<ApiService>().endpoint}/explorer/transaction/${websiteVersionTx.address}',
                                                ),
                                              );
                                            },
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
