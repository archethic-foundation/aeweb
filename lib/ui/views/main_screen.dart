import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/side_menu.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:aeweb/ui/views/website/website_versions_list.dart';
import 'package:aeweb/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websiteSelection =
        ref.watch(SelectedWebsiteProviders.selectedWebsiteProvider);
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Expanded(
              flex: 6,
              child: WebsiteList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: WebsiteVersionsList(
                genesisAddress: websiteSelection.genesisAddress,
                websiteName: websiteSelection.name,
              ),
            ),
          ],
        ),
        tablet: Row(
          children: [
            const Expanded(
              flex: 6,
              child: WebsiteList(),
            ),
            Expanded(
              flex: 9,
              child: WebsiteVersionsList(
                genesisAddress: websiteSelection.genesisAddress,
                websiteName: websiteSelection.name,
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: const SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 2 : 5,
              child: const WebsiteList(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: WebsiteVersionsList(
                genesisAddress: websiteSelection.genesisAddress,
                websiteName: websiteSelection.name,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
