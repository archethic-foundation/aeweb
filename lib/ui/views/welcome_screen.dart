import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/util/components/gradient_card.dart';
import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:aeweb/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                    children: const [
                      SizedBox(
                        height: 20,
                      ),
                      Text('Welcome'),
                    ],
                  ),
                  tablet: Row(
                    children: const [
                      Expanded(
                        flex: 6,
                        child: WebsiteList(),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text('Welcome'),
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
                            'WELCOME',
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
                                GradientCard(
                                  strokeWidth: 1,
                                  radius: 16,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0.1),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0x003C89B9),
                                      Color(0xFFCC00FF),
                                    ],
                                    stops: [0, 1],
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height: 350,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Easy, Secure and Simple way to Build',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'The AEWeb experience enables you to deploy your website with just a few clicks.\n\nThe interface is simple, secure, and user-friendly, making it easy for you to deploy your website effortlessly, even if you have zero coding knowledge.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
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
                                GradientCard(
                                  strokeWidth: 1,
                                  radius: 16,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0.1),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0x003C89B9),
                                      Color(0xFFCC00FF),
                                    ],
                                    stops: [0, 1],
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height: 350,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          '100% Secure & Tamperproof',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Do I have to worry about security and maintenance once I deploy my website?\nNo!\n\nAEWeb is decentralized and backed by Arch Consensus, which has the capability to handle up to 90% of malicious activity in the network.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
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
                                GradientCard(
                                  strokeWidth: 1,
                                  radius: 16,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0.1),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0x003C89B9),
                                      Color(0xFFCC00FF),
                                    ],
                                    stops: [0, 1],
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height: 350,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Minimum Transaction and Maintenance Cost',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Enjoy 3 to 5 times lower deployment and maintenance fees compared to well-known hosting services like AWS, Google Cloud, and more.\n\nAdditionally, the data will be geographically distributed across the globe, ensuring the highest level of data availability and security.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
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
                                GradientCard(
                                  strokeWidth: 1,
                                  radius: 16,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0.1),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0x003C89B9),
                                      Color(0xFFCC00FF),
                                    ],
                                    stops: [0, 1],
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height: 350,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Built-in Optimized Scalability',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'AEWeb, built on the Archethic blockchain, offers both linear and horizontal scalability for your website.\n\nThere is no comparable product that can provide hassle-free deployment and simultaneous scalability like AEWeb does',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
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
