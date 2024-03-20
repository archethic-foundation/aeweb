import 'dart:developer';

import 'package:aeweb/domain/usecases/website/read_website_version.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/update_website_sync_sheet.dart';
import 'package:aeweb/ui/views/util/warning_size_label.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PathSyncPopup with FileMixin {
  static Future<void> getDialog(
    BuildContext context,
    String transactionRefAddress,
    String websiteName,
    String genesisAddress,
  ) async {
    String? path;
    Uint8List? zipFile;
    bool? applyGitIgnoreRules;
    final thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      },
    );

    return showDialog(
      context: context,
      builder: (context) {
        return aedappfm.PopupTemplate(
          popupTitle: AppLocalizations.of(context)!.pathSyncPopupTitle,
          popupHeight: 320,
          popupContent: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  if (kIsWeb)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .pathSyncPopupSelectArchiveFile,
                            ),
                            const SizedBox(width: 2),
                            TextButton(
                              onPressed: () async {
                                try {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'zip',
                                      '7z',
                                      'rar',
                                    ],
                                  );
                                  if (result != null) {
                                    zipFile = result.files.first.bytes;
                                    setState(
                                      () {
                                        path = result.files.first.name;
                                      },
                                    );
                                  }
                                } on Exception catch (e) {
                                  log('Error while picking folder: $e');
                                }
                              },
                              child: const Icon(Icons.folder),
                            ),
                          ],
                        ),
                        Text(
                          path ?? '',
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .pathSyncPopupSelectFolder,
                            ),
                            const SizedBox(width: 2),
                            TextButton(
                              onPressed: () async {
                                try {
                                  final result = await FilePicker.platform
                                      .getDirectoryPath();
                                  if (result != null) {
                                    setState(
                                      () {
                                        path = '$result/';
                                      },
                                    );
                                  }
                                } on Exception catch (e) {
                                  log('Error while picking folder: $e');
                                }
                              },
                              child: const Icon(Icons.folder),
                            ),
                          ],
                        ),
                        Text(
                          path ?? '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const WarningSizeLabel(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .pathSyncPopupGitignoreLabel,
                      ),
                      const SizedBox(width: 2),
                      SizedBox(
                        height: 30,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            thumbIcon: thumbIcon,
                            value: applyGitIgnoreRules ?? false,
                            onChanged: (value) {
                              setState(
                                () {
                                  applyGitIgnoreRules = value;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      aedappfm.IconButtonAnimated(
                        icon: Icon(
                          Icons.help,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          launchUrl(
                            Uri.parse(
                              'https://wiki.archethic.net/FAQ/aeweb#what-is-the-purpose-of-a-gitignore-file',
                            ),
                          );
                        },
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  aedappfm.AppButton(
                    labelBtn: AppLocalizations.of(context)!.btn_sync,
                    onPressed: () async {
                      late final Map<String, HostingRefContentMetaData>?
                          localFiles;
                      if (kIsWeb) {
                        if (zipFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(context)
                                  .snackBarTheme
                                  .backgroundColor,
                              content: Text(
                                AppLocalizations.of(context)!
                                    .pathSyncPopupArchiveFileMissing,
                                style: Theme.of(context)
                                    .snackBarTheme
                                    .contentTextStyle,
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          return;
                        }
                        localFiles = await FileMixin.listFilesFromZip(
                          zipFile!,
                          applyGitIgnoreRules: applyGitIgnoreRules ?? false,
                        );
                      } else {
                        if (path == null || path!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Theme.of(context)
                                  .snackBarTheme
                                  .backgroundColor,
                              content: Text(
                                AppLocalizations.of(context)!
                                    .pathSyncPopupPathMissing,
                                style: Theme.of(context)
                                    .snackBarTheme
                                    .contentTextStyle,
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        localFiles = await FileMixin.listFilesFromPath(
                          path!,
                          applyGitIgnoreRules: applyGitIgnoreRules ?? false,
                        );
                      }

                      final remoteFiles =
                          (await ReadWebsiteVersionUseCases().getRemote(
                        transactionRefAddress,
                      ))!
                              .content!
                              .metaData;

                      context
                        ..pop() // close popup
                        ..go(
                          UpdateWebsiteSyncSheet.routerPage,
                          extra: {
                            'websiteName': websiteName,
                            'genesisAddress': genesisAddress,
                            'path': path ?? '',
                            'zipFile': zipFile ?? Uint8List.fromList([]),
                            'localFiles': localFiles,
                            'comparedFiles':
                                SyncWebsiteUseCases().compareFileLists(
                              localFiles!,
                              remoteFiles,
                            ),
                          },
                        );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
