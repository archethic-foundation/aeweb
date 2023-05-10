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
    late final _colorScheme = Theme.of(context).colorScheme;
    final thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        // Thumb icon when the switch is selected.
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
                      content: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Sélectionnez le dossier racine de votre site web',
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
                                  const Text(
                                    'Apply .gitignore rules?',
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
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (path == null || path!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please, select a folder',
                                          ),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }

                                    final remoteFiles =
                                        (await ReadWebsiteUseCases().getRemote(
                                      transactionRefAddress,
                                    ))!
                                            .content!
                                            .metaData;

                                    final localFiles =
                                        await FileMixin.listFilesFromPath(
                                      path!,
                                      applyGitIgnoreRules:
                                          applyGitIgnoreRules ?? false,
                                    );

                                    context.goNamed(
                                      'updateWebsiteSync',
                                      extra: {
                                        'websiteName': websiteName,
                                        'genesisAddress': genesisAddress,
                                        'path': path,
                                        'localFiles': localFiles,
                                        'comparedFiles': SyncWebsiteUseCases()
                                            .compareFileLists(
                                          localFiles!,
                                          remoteFiles,
                                        ),
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Sync',
                                    style: TextStyle(
                                      color: _colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
