import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList = ref.watch(WebsitesProviders.fetchWebsites);

    return websitesList.map(
      data: (data) {
        return Expanded(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 30,
                left: 10,
                right: 10,
              ),
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
          ),
        );
      },
      error: (error) => const SizedBox(),
      loading: (loading) => const Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: LinearProgressIndicator(
          minHeight: 1,
        ),
      ),
    );
  }
}

Widget _buildWebsiteCard(BuildContext context, WidgetRef ref, Website website) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
        height: 60,
        child: DecoratedBox(
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
        )),
  );
}

Widget _contentCard(BuildContext context, WidgetRef ref, Website website) {
  return InkWell(
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    onTap: () {
      final session = ref.watch(SessionProviders.session);
      if (session.isConnected) {
        context.push(
          RoutesPath().websiteDetails(website.name),
          extra: {
            'genesisAddress': website.genesisAddress,
          },
        );
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          website.name,
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}
