import 'package:aeweb/application/website_list_display.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/ui/views/website/website_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWebsitesList = ref.watch(WebsitesProviders.fetchWebsites);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(websiteListDisplayProvider)
                  ? Icons.view_list
                  : Icons.grid_view,
            ),
            onPressed: () {
              ref.read(websiteListDisplayProvider.notifier).toggle();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebsiteAdd(),
                ),
              );
            },
          ),
        ],
      ),
      body: ref.watch(websiteListDisplayProvider)
          ? _buildGrid(asyncWebsitesList)
          : _buildList(asyncWebsitesList),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, color: Colors.white),
          label: 'Documentation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gavel, color: Colors.white),
          label: 'Terms of Use',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.privacy_tip, color: Colors.white),
          label: 'Privacy Policy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code, color: Colors.white),
          label: 'Source Code',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help_outline, color: Colors.white),
          label: 'FAQ',
        ),
      ],
      onTap: (int index) {
        String? url;
        switch (index) {
          case 0:
            url =
                'https://archethic-foundation.github.io/archethic-docs/participate/aeweb';
            break;
          case 1:
            url = '#';
            break;
          case 2:
            url = '#';
            break;
          case 3:
            url = 'https://github.com/archethic-foundation/aeweb';
            break;
          case 4:
            url =
                'https://archethic-foundation.github.io/archethic-docs/category/FAQ';
            break;
        }
        if (url != null) {
          launchUrl(Uri.parse(url));
        }
      },
    );
  }

  Widget _buildGrid(AsyncValue<List<Website>> asyncWebsitesList) {
    return asyncWebsitesList.map(
      data: (data) {
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: data.value.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            return _buildWebsiteCard(data.value[index]);
          },
        );
      },
      error: (error) => const SizedBox(),
      loading: (loading) => const SizedBox(),
    );
  }

  Widget _buildList(AsyncValue<List<Website>> asyncWebsitesList) {
    return asyncWebsitesList.map(
      data: (data) {
        return ListView.builder(
          itemCount: data.value.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeaderRow();
            }
            return _buildWebsiteRow(data.value[index - 1]);
          },
        );
      },
      error: (error) => const SizedBox(),
      loading: (loading) => const SizedBox(),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.grey[800],
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: const [
          Expanded(child: Text('Name')),
          Expanded(child: Text('Genesis Address')),
          Expanded(child: Text('Size (Mo)')),
          Expanded(child: Text('Nb of Transactions')),
          Expanded(child: Text('Last Publication Fees')),
          Expanded(child: Text('Global Fees')),
        ],
      ),
    );
  }

  Widget _buildWebsiteRow(Website website) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(child: Text(website.name)),
          Expanded(child: Text(website.genesisAddress)),
          Expanded(child: Text(website.size)),
          Expanded(child: Text(website.nbTransactions)),
          Expanded(child: Text(website.lastPublicationFees)),
          Expanded(child: Text(website.globalFees)),
          _popupMenuButton(),
        ],
      ),
    );
  }

  Widget _popupMenuButton() {
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
    );
  }

  Widget _buildWebsiteCard(Website website) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/${website.name}.png'),
            ),
            const SizedBox(height: 16),
            Text(
              website.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              website.genesisAddress,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Size (Mo): ${website.size}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Nb of Transactions: ${website.nbTransactions}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Last Publication Fees: ${website.lastPublicationFees}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Global Fees: ${website.globalFees}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            _popupMenuButton(),
          ],
        ),
      ),
    );
  }
}
