/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/website_version_tx.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorerTxScreen extends ConsumerWidget {
  const ExplorerTxScreen({super.key, required this.websiteVersionTxList});

  final List<WebsiteVersionTx> websiteVersionTxList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height - 380,
      padding: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0x003C89B9),
              Color(0xFFCC00FF),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SelectionArea(
                      child: Text(
                        AppLocalizations.of(context)!.explorerTxTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x003C89B9),
                            Color(0xFFCC00FF),
                          ],
                          stops: [0, 1],
                          begin: AlignmentDirectional.centerEnd,
                          end: AlignmentDirectional.centerStart,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (websiteVersionTxList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.warning_2),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .websitesListVersionsNoVersion,
                      ),
                    ],
                  ),
                )
              else
                Align(
                  child: DataTable(
                    horizontalMargin: 0,
                    columnSpacing: 10,
                    dividerThickness: 1,
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
                                    child:
                                        websiteVersionTx.typeHostingTx == 'ref'
                                            ? const Icon(
                                                Iconsax.receipt_text,
                                              )
                                            : const Icon(Iconsax.document),
                                  ),
                                ),
                                DataCell(
                                  Align(
                                    child: SelectableText(
                                      websiteVersionTx.address.toLowerCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
