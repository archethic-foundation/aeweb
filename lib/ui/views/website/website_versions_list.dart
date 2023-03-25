import 'package:aeweb/application/websites.dart';
import 'package:aeweb/domain/usecases/website/create_website.dart';
import 'package:aeweb/domain/usecases/website/read_website.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/ui/views/bottom_bar.dart';
import 'package:aeweb/ui/views/website/explorer.dart';
import 'package:aeweb/ui/views/website/file_comparison.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: websitesList.map(
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
          value: 'Create',
          child: Row(
            children: const [
              Icon(Icons.create),
              SizedBox(width: 8),
              Flexible(
                child: Text('Create'),
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
        case 'Create':
          CreateWebsiteUseCases().createWebsite(
            'test1${DateTime.now().microsecond}',
            '/Volumes/Macintosh HD/Users/SSE/SSE/app/ARCHETHIC/archethic-website/',
          );

          break;
        case 'Sync':
          // TODO(reddwarf03): Récupérer le path local
          // final localFiles = await listFilesFromPath(
          //   '/Volumes/Macintosh HD/Users/SSE/SSE/app/ARCHETHIC/archethic-website/',
          // );
          final remoteFiles = (await ReadWebsiteUseCases()
                  .getRemote(websiteVersion.transactionAddress))!
              .content!
              .metaData;

          //ReadWebsiteUseCases().getLocal(address);

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
