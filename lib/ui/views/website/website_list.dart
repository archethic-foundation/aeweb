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
    late final _colorScheme = Theme.of(context).colorScheme;
    late final _backgroundColor =
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3);

    return Scaffold(
      key: _scaffoldKey,
      body: ColoredBox(
        color: _backgroundColor,
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
                loading: (loading) => const LinearProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildWebsiteCard(BuildContext context, WidgetRef ref, Website website) {
  final selectedWebsite =
      ref.watch(SelectedWebsiteProviders.selectedWebsiteProvider);
  return Container(
    height: 100,
    padding: const EdgeInsets.all(10),
    child: selectedWebsite.genesisAddress != website.genesisAddress
        ? Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: _contentCard(context, ref, website),
          )
        : Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            child: _contentCard(context, ref, website),
          ),
  );
}

Widget _contentCard(BuildContext context, WidgetRef ref, Website website) {
  return InkWell(
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
  );
}
