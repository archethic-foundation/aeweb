import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/ui/views/bottom_bar.dart';
import 'package:aeweb/ui/views/website/website_versions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList = ref.watch(WebsitesProviders.fetchWebsites);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Websites'),
      ),
      body: websitesList.map(
        data: (data) {
          return Container(
            padding: const EdgeInsets.only(top: 100),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.value.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildWebsiteAddCard();
                } else {
                  return _buildWebsiteCard(context, data.value[index - 1]);
                }
              },
            ),
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

Widget _buildWebsiteCard(BuildContext context, Website website) {
  return Padding(
    padding: const EdgeInsets.only(left: 40, right: 40),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebsiteVersionsList(
                genesisAddress: website.genesisAddress,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              website.name,
              style: const TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildWebsiteAddCard() {
  return Padding(
    padding: const EdgeInsets.only(left: 40, right: 40),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.add_circle_outline,
            size: 40,
          )
        ],
      ),
    ),
  );
}
