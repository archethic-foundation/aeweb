import 'package:aeweb/ui/views/display_website/website_list.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/util/header.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_advert.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_connect_wallet_btn.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_info_version.dart';
import 'package:aeweb/util/external/pageview_dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  late int selectedPage;
  late final PageController pageController;

  @override
  void initState() {
    selectedPage = 0;
    pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 4;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background-welcome.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00000000),
                  const Color(0xFFCC00FF).withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Header(),
              ),
              Expanded(
                child: Responsive(
                  mobile: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (page) {
                            setState(() {
                              selectedPage = page;
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg1Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg1Desc,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg2Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg2Desc,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg3Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg3Desc,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg4Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg4Desc,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: PageViewDotIndicator(
                          currentItem: selectedPage,
                          count: pageCount,
                          unselectedColor: Colors.white,
                          selectedColor: const Color(0xFF00A4DB),
                          duration: const Duration(milliseconds: 200),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const WelcomeConnectWalletBtn(),
                      const SizedBox(height: 20),
                      const WelcomeInfoVersion(),
                    ],
                  ),
                  tablet: Row(
                    children: const [
                      Expanded(
                        flex: 6,
                        child: WebsiteList(),
                      ),
                    ],
                  ),
                  desktop: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 60),
                        width: MediaQuery.of(context).size.width,
                        height: 420,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg1Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg1Desc,
                              )
                                  .animate()
                                  .fade(
                                    duration: const Duration(milliseconds: 200),
                                  )
                                  .scale(
                                    duration: const Duration(milliseconds: 200),
                                  ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg2Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg2Desc,
                              )
                                  .animate()
                                  .fade(
                                    duration: const Duration(milliseconds: 250),
                                  )
                                  .scale(
                                    duration: const Duration(milliseconds: 250),
                                  ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg3Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg3Desc,
                              )
                                  .animate()
                                  .fade(
                                    duration: const Duration(milliseconds: 300),
                                  )
                                  .scale(
                                    duration: const Duration(milliseconds: 300),
                                  ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: WelcomeAdvert(
                                welcomeArgTitle: AppLocalizations.of(context)!
                                    .welcomeArg4Title,
                                welcomeArgDesc: AppLocalizations.of(context)!
                                    .welcomeArg4Desc,
                              )
                                  .animate()
                                  .fade(
                                    duration: const Duration(milliseconds: 350),
                                  )
                                  .scale(
                                    duration: const Duration(milliseconds: 350),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const WelcomeConnectWalletBtn(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width - 300,
                        ),
                        child: const WelcomeInfoVersion(),
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
