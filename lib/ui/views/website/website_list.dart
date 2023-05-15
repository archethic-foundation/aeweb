import 'package:aeweb/application/main_screen_third_part.dart';
import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList = ref.watch(WebsitesProviders.fetchWebsites);

    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xFFCC00FF),
              Color(0x003C89B9),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectionArea(
                  child: Text(
                    AppLocalizations.of(context)!.websitesListTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 25,
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x003C89B9),
                        Color(0xFFCC00FF),
                      ],
                      stops: [0, 1],
                      begin: AlignmentDirectional.centerEnd,
                      end: AlignmentDirectional.centerStart,
                    ),
                  ),
                ),
              ),
              IconButtonAnimated(
                onPressed: () {
                  context.go('/addWebsite');
                },
                icon: const Icon(Iconsax.add_circle),
                tooltip: AppLocalizations.of(context)!.tooltip_addNewWebsite,
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButtonAnimated(
                onPressed: () {
                  ref.read(WebsitesProviders.fetchWebsites);
                },
                icon: const Icon(Iconsax.global_refresh),
                tooltip: AppLocalizations.of(context)!.tooltip_refreshWebsite,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
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
            loading: (loading) => Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: MediaQuery.of(context).size.height - 200,
              ),
              child: const LinearProgressIndicator(
                minHeight: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildWebsiteCard(BuildContext context, WidgetRef ref, Website website) {
  final selectedWebsite =
      ref.watch(SelectedWebsiteProviders.selectedWebsiteProvider);
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      height: 60,
      child: selectedWebsite.genesisAddress != website.genesisAddress
          ? DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(1),
                    Theme.of(context).colorScheme.background.withOpacity(0.3),
                  ],
                  stops: const [0, 1],
                ),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.background.withOpacity(0.5),
                      Theme.of(context).colorScheme.background.withOpacity(0.7),
                    ],
                    stops: const [0, 1],
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _contentCard(context, ref, website),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(1),
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                  ],
                  stops: const [0, 1],
                ),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(1),
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                    ],
                    stops: const [0, 1],
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _contentCard(context, ref, website),
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
      ref
          .read(
            MainScreenThirdPartProviders.mainScreenThirdPartProvider.notifier,
          )
          .setWidget(const SizedBox());
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
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
                  Text(
                    AppLocalizations.of(context)!.btn_view,
                    style: textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
