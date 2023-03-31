import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/side_menu.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/responsive.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList = ref.watch(WebsitesProviders.fetchWebsites);

    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(),
      ),
      body: SizedBox(
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              if (!Responsive.isDesktop(context))
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
              const Text(
                'Your websites',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              if (!Responsive.isDesktop(context)) const SizedBox(width: 20),
              websitesList.map(
                data: (data) {
                  return Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: data.value.length,
                        itemBuilder: (context, index) {
                          return _buildWebsiteCard(
                            context,
                            ref,
                            data.value[index],
                          );
                        },
                      ),
                    ),
                  );
                },
                error: (error) => const SizedBox(),
                loading: (loading) => const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildWebsiteCard(BuildContext context, WidgetRef ref, Website website) {
  return Container(
    height: 100,
    padding: const EdgeInsets.only(
      left: 10,
      right: 10,
      top: 10,
      bottom: 10,
    ),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          ref
              .read(SelectedWebsiteProviders.selectedWebsiteProvider.notifier)
              .setSelection(website.genesisAddress, website.name);
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
            InkWell(
              onTap: () {
                final url =
                    '${sl.get<ApiService>().endpoint}/api/web_hosting/${website.genesisAddress}';
                launchUrl(
                  Uri.parse(
                    url,
                  ),
                );
              },
              child: const Icon(
                Icons.remove_red_eye_outlined,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
