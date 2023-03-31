import 'dart:developer';

import 'package:aeweb/domain/usecases/website/read_website.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PathSyncPopup with FileMixin {
  static Future<void> getDialog(
    BuildContext context,
    String transactionRefAddress,
    String websiteName,
    String genesisAddress,
  ) async {
    String? path;
    bool? applyGitIgnoreRules;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10,
              ),
              content: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
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
                            icon: const Icon(Icons.folder),
                            label: Text(
                              'Sélectionnez le dossier racine de votre site web',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          Text(
                            path ?? '',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Apply .gitignore rules?',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          Switch(
                            value: applyGitIgnoreRules ?? false,
                            onChanged: (value) {
                              setState(
                                () {
                                  applyGitIgnoreRules = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            final remoteFiles = (await ReadWebsiteUseCases()
                                    .getRemote(transactionRefAddress))!
                                .content!
                                .metaData;

                            final localFiles =
                                await FileMixin.listFilesFromPath(
                              path!,
                              applyGitIgnoreRules: applyGitIgnoreRules ?? false,
                            );

                            context.goNamed(
                              'updateWebsiteSync',
                              extra: {
                                'websiteName': websiteName,
                                'genesisAddress': genesisAddress,
                                'path': path,
                                'localFiles': localFiles,
                                'comparedFiles':
                                    SyncWebsiteUseCases().compareFileLists(
                                  localFiles!,
                                  remoteFiles,
                                ),
                              },
                            );
                          },
                          child: const Text(
                            'Sync',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
