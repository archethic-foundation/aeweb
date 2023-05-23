import 'package:aeweb/application/main_screen_third_part.dart';
import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/navigation_drawer_section.dart';
import 'package:aeweb/ui/views/display_website/website_list.dart';
import 'package:aeweb/ui/views/display_website/website_versions_list.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final websiteSelection =
        ref.watch(SelectedWebsiteProviders.selectedWebsiteProvider);
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Responsive(
        mobile: Container(
          height: MediaQuery.of(context).size.height - 100,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
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
                flex: 10,
                child: WebsiteVersionsList(
                  genesisAddress: websiteSelection.genesisAddress,
                  websiteName: websiteSelection.name,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ref.watch(
                MainScreenThirdPartProviders.mainScreenThirdPartProvider,
              ),
            ],
          ),
        ),
        tablet: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: _size.width > 1340 ? 3 : 4,
              child: const Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                  left: 30,
                  right: 10,
                ),
                child: NavigationDrawerSection(),
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 200))
                  .scale(duration: const Duration(milliseconds: 200)),
            ),
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
                    if (websiteSelection.genesisAddress.isNotEmpty)
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
                    ref.watch(
                      MainScreenThirdPartProviders.mainScreenThirdPartProvider,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: _size.width > 1340 ? 3 : 4,
              child: const Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                  left: 30,
                  right: 10,
                ),
                child: NavigationDrawerSection(),
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 200))
                  .scale(duration: const Duration(milliseconds: 200)),
            ),
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
                    if (websiteSelection.genesisAddress.isNotEmpty)
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
                    ref.watch(
                      MainScreenThirdPartProviders.mainScreenThirdPartProvider,
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
}
