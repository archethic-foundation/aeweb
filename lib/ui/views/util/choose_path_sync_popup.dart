import 'dart:developer';

import 'package:aeweb/domain/usecases/website/read_website_version.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
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
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.only(
                        top: 10,
                      ),
                      content: Container(
                        color: Colors.transparent,
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                SelectionArea(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .pathSyncPopupTitle,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    width: 25,
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
                            const SizedBox(
                              width: 500,
                              height: 20,
                            ),
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
                                            final result = await FilePicker
                                                .platform
                                                .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'zip',
                                                '7z',
                                                'rar'
                                              ],
                                            );
                                            if (result != null) {
                                              zipFile =
                                                  result.files.first.bytes;
                                              setState(
                                                () {
                                                  path =
                                                      result.files.first.name;
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
                                            final result = await FilePicker
                                                .platform
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
                                IconButtonAnimated(
                                  icon: const Icon(Icons.help),
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                        'https://wiki.archethic.net/FAQ/aeweb#what-is-the-purpose-of-a-gitignore-file',
                                      ),
                                    );
                                  },
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton(
                                    labelBtn:
                                        AppLocalizations.of(context)!.btn_close,
                                    icon: Iconsax.close_square,
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  AppButton(
                                    labelBtn:
                                        AppLocalizations.of(context)!.btn_sync,
                                    icon: Iconsax.refresh_circle,
                                    onPressed: () async {
                                      late final Map<String,
                                              HostingRefContentMetaData>?
                                          localFiles;
                                      if (kIsWeb) {
                                        if (zipFile == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                          return;
                                        }
                                        localFiles =
                                            await FileMixin.listFilesFromZip(
                                          zipFile!,
                                          applyGitIgnoreRules:
                                              applyGitIgnoreRules ?? false,
                                        );
                                      } else {
                                        if (path == null || path!.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                          return;
                                        }

                                        localFiles =
                                            await FileMixin.listFilesFromPath(
                                          path!,
                                          applyGitIgnoreRules:
                                              applyGitIgnoreRules ?? false,
                                        );
                                      }

                                      final remoteFiles =
                                          (await ReadWebsiteVersionUseCases()
                                                  .getRemote(
                                        transactionRefAddress,
                                      ))!
                                              .content!
                                              .metaData;

                                      context.goNamed(
                                        'updateWebsiteSync',
                                        extra: {
                                          'websiteName': websiteName,
                                          'genesisAddress': genesisAddress,
                                          'path': path ?? '',
                                          'zipFile':
                                              zipFile ?? Uint8List.fromList([]),
                                          'localFiles': localFiles,
                                          'comparedFiles': SyncWebsiteUseCases()
                                              .compareFileLists(
                                            localFiles!,
                                            remoteFiles,
                                          ),
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
