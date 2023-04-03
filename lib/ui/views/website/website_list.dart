import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/responsive.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList = ref.watch(WebsitesProviders.fetchWebsites);

    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox(
        child: SafeArea(
          right: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!Responsive.isDesktop(context))
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
              if (!Responsive.isDesktop(context)) const SizedBox(width: 20),
              websitesList.map(
                data: (data) {
                  return Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: data.value.length + 1,
                        itemBuilder: (context, index) {
                          if (index == data.value.length) {
                            return _buildAddWebsiteCard(context);
                          }
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
            color: Theme.of(context).colorScheme.onInverseSurface,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: _contentCard(context, ref, website),
          )
        : Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: _contentCard(context, ref, website),
          ),
  );
}

Widget _buildAddWebsiteCard(BuildContext context) {
  return Container(
    height: 100,
    padding: const EdgeInsets.all(10),
    child: Card(
      color: Theme.of(context).colorScheme.onInverseSurface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          context.go('/addWebsite');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_circle_outline,
              size: 20,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _contentCard(BuildContext context, WidgetRef ref, Website website) {
  final textTheme = Theme.of(context)
      .textTheme
      .apply(displayColor: Theme.of(context).colorScheme.onSurface);

  return InkWell(
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    onTap: () {
      ref
          .read(SelectedWebsiteProviders.selectedWebsiteProvider.notifier)
          .setSelection(website.genesisAddress, website.name);
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            website.name,
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 100,
            height: 20,
            child: OutlinedButton(
              onPressed: () async {
                final url =
                    '${sl.get<ApiService>().endpoint}/api/web_hosting/${website.genesisAddress}';
                launchUrl(
                  Uri.parse(
                    url,
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 11,
                  ),
                  const SizedBox(width: 4),
                  Text('View', style: textTheme.labelSmall),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
