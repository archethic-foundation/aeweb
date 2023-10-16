/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/main_screen_third_part.dart';
import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/display_website/website_list.dart';
import 'package:aeweb/ui/views/display_website/website_versions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body extends ConsumerWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websiteSelection =
        ref.watch(SelectedWebsiteProviders.selectedWebsiteProvider);
    final session = ref.watch(SessionProviders.session);
    final _size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: const Padding(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 30,
              left: 10,
              right: 10,
            ),
            child: WebsiteList(),
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 250))
              .scale(duration: const Duration(milliseconds: 250)),
        ),
        Expanded(
          flex: _size.width > 1340 ? 9 : 10,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 30,
              left: 10,
              right: 10,
            ),
            child: Column(
              children: [
                if (websiteSelection.genesisAddress.isNotEmpty &&
                    session.isConnected)
                  WebsiteVersionsList(
                    genesisAddress: websiteSelection.genesisAddress,
                    websiteName: websiteSelection.name,
                  )
                      .animate()
                      .fade(
                        duration: const Duration(milliseconds: 300),
                      )
                      .scale(
                        duration: const Duration(milliseconds: 300),
                      )
                else
                  const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                if (session.isConnected)
                  ref.watch(
                    MainScreenThirdPartProviders.mainScreenThirdPartProvider,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
