import 'package:aeweb/application/version.dart';
import 'package:aeweb/ui/views/display_website/website_list.dart';
import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/util/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVersionString = ref.watch(
      versionStringProvider(
        AppLocalizations.of(context)!,
      ),
    );

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
                    children: const [],
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
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(1),
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.3),
                                  ],
                                  stops: const [0, 1],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
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
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg1Title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg1Desc,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fade(
                                  duration: const Duration(milliseconds: 200),
                                )
                                .scale(
                                  duration: const Duration(milliseconds: 200),
                                ),
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(1),
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.3),
                                  ],
                                  stops: const [0, 1],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
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
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg2Title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg2Desc,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fade(
                                  duration: const Duration(milliseconds: 250),
                                )
                                .scale(
                                  duration: const Duration(milliseconds: 250),
                                ),
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(1),
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.3),
                                  ],
                                  stops: const [0, 1],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
                                border: const GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0x003C89B9),
                                      Color(0xFFCC00FF),
                                    ],
                                    stops: [0, 1],
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg3Title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg3Desc,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fade(
                                  duration: const Duration(milliseconds: 300),
                                )
                                .scale(
                                  duration: const Duration(milliseconds: 300),
                                ),
                            Container(
                              width: MediaQuery.of(context).size.width / 6,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(1),
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.3),
                                  ],
                                  stops: const [0, 1],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
                                border: const GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0x003C89B9),
                                      Color(0xFFCC00FF),
                                    ],
                                    stops: [0, 1],
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg4Title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .welcomeArg4Desc,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fade(
                                  duration: const Duration(milliseconds: 350),
                                )
                                .scale(
                                  duration: const Duration(milliseconds: 350),
                                ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            width: 300,
                            child: ConnectionToWalletStatus(),
                          ),
                          InkWell(
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                  'https://www.archethic.net/aewallet.html',
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.welcomeNoWallet,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width - 300,
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/AELogo-Public Blockchain-White.svg',
                              semanticsLabel: 'AE Logo',
                              height: 30,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              asyncVersionString.asData?.value ?? '',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
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
