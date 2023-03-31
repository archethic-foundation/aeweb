import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/ui/views/bottom_bar.dart';
import 'package:aeweb/ui/views/util/components/choose_path_sync_popup.dart';
import 'package:aeweb/ui/views/website/explorer.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            child: websiteVersionsList.map(
              data: (data) {
                return ListView.builder(
                  itemCount: websiteVersionsList.value!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeaderRow();
                    }
                    return _buildWebsiteRow(
                      context,
                      ref,
                      index == 1,
                      websiteVersionsList.value![index - 1],
                      websiteName,
                      genesisAddress,
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
  bool lastVersion,
  WebsiteVersion websiteVersion,
  String websiteName,
  String genesisAddress,
) {
  return Container(
    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: SelectableText(websiteVersion.transactionRefAddress)),
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
        _popupMenuButton(
          context,
          ref,
          lastVersion,
          websiteVersion,
          websiteName,
          genesisAddress,
        ),
      ],
    ),
  );
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExplorerScreen(filesAndFolders: websiteVersion.content!),
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
