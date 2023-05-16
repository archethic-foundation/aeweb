import 'package:aeweb/application/main_screen_third_part.dart';
import 'package:aeweb/application/selected_website.dart';
import 'package:aeweb/navigation_drawer_section.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:aeweb/ui/views/website/website_versions_list.dart';
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
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00000000),
                  const Color(0x00000000).withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Responsive(
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
                      if (websiteSelection.genesisAddress.isNotEmpty)
                        WebsiteVersionsList(
                          genesisAddress: websiteSelection.genesisAddress,
                          websiteName: websiteSelection.name,
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
                                  genesisAddress:
                                      websiteSelection.genesisAddress,
                                  websiteName: websiteSelection.name,
                                )
                                    .animate()
                                    .fade(
                                      duration:
                                          const Duration(milliseconds: 300),
                                    )
                                    .scale(
                                      duration:
                                          const Duration(milliseconds: 300),
                                    )
                              else
                                const SizedBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              ref.watch(
                                MainScreenThirdPartProviders
                                    .mainScreenThirdPartProvider,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
