import 'dart:developer';
import 'dart:io';

import 'package:aeweb/application/websites.dart';
import 'package:aeweb/domain/usecases/website/read_website.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/ui/views/bottom_bar.dart';
import 'package:aeweb/ui/views/website/explorer.dart';
import 'package:aeweb/ui/views/website/file_comparison.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class WebsiteVersionsList extends ConsumerWidget with FileMixin {
  const WebsiteVersionsList({super.key, required this.genesisAddress});

  final String genesisAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList =
        ref.watch(WebsitesProviders.fetchWebsiteVersions(genesisAddress));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SelectableText('Version history: $genesisAddress'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: websitesList.map(
              data: (data) {
                return ListView.builder(
                  itemCount: websitesList.value!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeaderRow();
                    }
                    return _buildWebsiteRow(
                      context,
                      ref,
                      websitesList.value![index - 1],
                    );
                  },
                );
              },
              error: (error) => const SizedBox(),
              loading: (loading) => const SizedBox(
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

Widget _buildHeaderRow() {
  return Container(
    color: Colors.grey[800],
    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Expanded(child: Text('Tx address')),
        SizedBox(width: 20),
        Expanded(child: Text('Date')),
        SizedBox(width: 20),
        Expanded(child: Text('Publisher')),
        SizedBox(width: 20),
        Expanded(child: Text('Files')),
        SizedBox(width: 20),
        Expanded(child: Text('Size')),
      ],
    ),
  );
}

Widget _buildWebsiteRow(
  BuildContext context,
  WidgetRef ref,
  WebsiteVersion websiteVersion,
) {
  return Container(
    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: SelectableText(websiteVersion.transactionAddress)),
        const SizedBox(width: 20),
        Expanded(
          child: SelectableText(
            DateFormat.yMd(
              Localizations.localeOf(context).languageCode,
            ).add_Hms().format(
                  DateTime.fromMillisecondsSinceEpoch(
                    websiteVersion.timestamp * 1000,
                  ).toLocal(),
                ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: SelectableText(websiteVersion.publisher)),
        const SizedBox(width: 20),
        Expanded(child: SelectableText(websiteVersion.filesCount.toString())),
        const SizedBox(width: 20),
        Expanded(
          child: SelectableText(filesize(websiteVersion.size.toString())),
        ),
        _popupMenuButton(context, websiteVersion),
      ],
    ),
  );
}

Widget _popupMenuButton(BuildContext context, WebsiteVersion websiteVersion) {
  return PopupMenuButton(
    constraints: const BoxConstraints.expand(width: 300, height: 250),
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
        PopupMenuItem(
          value: 'Upload',
          child: Row(
            children: const [
              Icon(Icons.cloud_upload),
              SizedBox(width: 8),
              Flexible(
                child: Text('Upload'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Sync',
          child: Row(
            children: const [
              Icon(Icons.sync),
              SizedBox(width: 8),
              Flexible(
                child: Text('Sync'),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExplorerScreen(filesAndFolders: websiteVersion.content!),
            ),
          );
          break;
        case 'Sync':
          await showDialog(
              context: context,
              builder: (context) {
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
                                onPressed: _selectFilePath,
                                icon: const Icon(Icons.folder),
                                label: Text(
                                  'Sélectionnez le dossier racine de votre site web',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              Text(''),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
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
              });
          final remoteFiles = (await ReadWebsiteUseCases()
                  .getRemote(websiteVersion.transactionAddress))!
              .content!
              .metaData;

          ReadWebsiteUseCases().getLocal(websiteVersion.transactionAddress);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileComparisonWidget(
                comparedFiles:
                    SyncWebsiteUseCases().compareFileLists({}, remoteFiles),
              ),
            ),
          );
          break;
        default:
      }
    },
  );
}

Future<void> _selectFilePath() async {
  try {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {}
  } on Exception catch (e) {
    log('Error while picking folder: $e');
  }
}
