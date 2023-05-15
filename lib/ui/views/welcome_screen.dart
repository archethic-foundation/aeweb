import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
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
              const Header(),
              Expanded(
                child: Responsive(
                  mobile: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.welcomeTitle,
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
                        child: Text(AppLocalizations.of(context)!.welcomeTitle),
                      ),
                    ],
                  ),
                  desktop: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.welcomeTitle,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color,
                              fontFamily: 'Equinox',
                              fontSize: 32,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: 350,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
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
                                            .welcomeArg1Title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .welcomeArg1Desc,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fade(
                                      duration:
                                          const Duration(milliseconds: 200),
                                    )
                                    .scale(
                                      duration:
                                          const Duration(milliseconds: 200),
                                    ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: 350,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
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
                                            .welcomeArg2Title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .welcomeArg2Desc,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fade(
                                      duration:
                                          const Duration(milliseconds: 250),
                                    )
                                    .scale(
                                      duration:
                                          const Duration(milliseconds: 250),
                                    ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: 350,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .welcomeArg3Desc,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fade(
                                      duration:
                                          const Duration(milliseconds: 300),
                                    )
                                    .scale(
                                      duration:
                                          const Duration(milliseconds: 300),
                                    ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: 350,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .welcomeArg4Desc,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fade(
                                      duration:
                                          const Duration(milliseconds: 350),
                                    )
                                    .scale(
                                      duration:
                                          const Duration(milliseconds: 350),
                                    ),
                              ],
                            ),
                          ),
                          const ConnectionToWalletStatus(),
                        ],
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
