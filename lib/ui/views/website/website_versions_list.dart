import 'package:aeweb/application/main_screen_third_part.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/ui/views/util/choose_path_sync_popup.dart';
import 'package:aeweb/ui/views/website/explorer.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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
        ref.watch(WebsitesProviders.fetchWebsiteVersions(genesisAddress));

    return Container(
      height: 300,
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
                        "Website's versions",
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
              websiteVersionsList.when(
                data: (websiteVersions) {
                  final versions = websiteVersions.cast<WebsiteVersion>();
                  if (versions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Iconsax.warning_2),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Aucune version disponible',
                          ),
                        ],
                      ),
                    );
                  }
                  return Align(
                    child: DataTable(
                      dividerThickness: 0,
                      columns: const [
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Date',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Files',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Size',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Actions',
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
                                    SelectableText(
                                      websiteVersion.filesCount.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    SelectableText(
                                      filesize(
                                        websiteVersion.size.toString(),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataCell(
                                    _popupMenuButton(
                                      context,
                                      ref,
                                      index == 0,
                                      websiteVersion,
                                      websiteName,
                                      genesisAddress,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .values
                          .toList(),
                    ),
                  );
                },
                error: (error, stacktrace) => const SizedBox(),
                loading: () => const SizedBox(),
              ),
            ],
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
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 'Explore',
          child: Row(
            children: const [
              Icon(Icons.explore),
              SizedBox(width: 8),
              Flexible(
                child: Text('Explore'),
              ),
            ],
          ),
        ),
        if (lastVersion)
          PopupMenuItem(
            value: 'Sync',
            child: Row(
              children: const [
                Icon(Icons.sync),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Sync from local folder'),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'Delete',
          child: Row(
            children: const [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Flexible(
                child: Text('Delete files and SSL certificate / key'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Download',
          child: Row(
            children: const [
              Icon(Icons.download),
              SizedBox(width: 8),
              Flexible(
                child: Text('Download'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Certificate',
          child: Row(
            children: const [
              Icon(Icons.security),
              SizedBox(width: 8),
              Flexible(
                child: Text('Certificate management'),
              ),
            ],
          ),
        ),
      ];
    },
    onSelected: (value) async {
      switch (value) {
        case 'Explore':
          ref
              .read(
                MainScreenThirdPartProviders
                    .mainScreenThirdPartProvider.notifier,
              )
              .setWidget(
                ExplorerScreen(
                  filesAndFolders: websiteVersion.content!,
                )
                    .animate()
                    .fade(
                      duration: const Duration(milliseconds: 350),
                    )
                    .scale(
                      duration: const Duration(milliseconds: 350),
                    ),
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
        default:
      }
    },
  );
}
