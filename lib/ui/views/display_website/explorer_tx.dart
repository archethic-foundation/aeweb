/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:math';

import 'package:aeweb/model/website_version_tx.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:aeweb/ui/views/util/components/main_background.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.explorerTxTitle,
        ),
      ),
      body: Stack(
        children: [
          const MainBackground(),
          if (websiteVersionTxList.isEmpty)
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.warning_2),
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ArchethicScrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                        child: websiteVersionTx.typeHostingTx ==
                                                'ref'
                                            ? const Icon(
                                                Iconsax.archive_book,
                                              )
                                            : const Icon(Iconsax.document),
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
                                        child: IconButtonAnimated(
                                          icon: const Icon(
                                            Iconsax.export_3,
                                          ),
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                '${sl.get<ApiService>().endpoint}/explorer/transaction/${websiteVersionTx.address}',
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
        ],
      ),
    );
  }
}
