import 'package:aeweb/application/version.dart';
import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDestination {
  const MenuDestination(this.label, this.icon);

  final String label;
  final Widget icon;
}

const List<MenuDestination> destinationsHosting = <MenuDestination>[
  MenuDestination(
    'Your websites',
    Icon(Iconsax.global),
  ),
  MenuDestination(
    'New website',
    Icon(Iconsax.add_circle),
  ),
];

const List<MenuDestination> destinationsInfos = <MenuDestination>[
  MenuDestination(
    'Documentation',
    Icon(Iconsax.document_text),
  ),
  MenuDestination(
    'Source Code',
    Icon(Iconsax.code_circle),
  ),
  MenuDestination(
    'FAQ',
    Icon(Iconsax.message_question),
  ),
];

class NavigationDrawerSection extends StatefulWidget {
  const NavigationDrawerSection({super.key});

  @override
  State<NavigationDrawerSection> createState() =>
      _NavigationDrawerSectionState();
}

class _NavigationDrawerSectionState extends State<NavigationDrawerSection> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: NavigationDrawer(
              elevation: 0,
              backgroundColor: Colors.transparent,
              onDestinationSelected: (selectedIndex) {
                setState(() {
                  navDrawerIndex = selectedIndex;
                });

                switch (selectedIndex) {
                  case 1:
                    context.go('/addWebsite');
                    break;
                  case 2:
                    launchUrl(
                      Uri.parse(
                        'https://wiki.archethic.net/participate/aeweb/',
                      ),
                    );
                    break;
                  case 3:
                    launchUrl(
                      Uri.parse(
                        'https://github.com/archethic-foundation/aeweb',
                      ),
                    );
                    break;
                  case 4:
                    launchUrl(
                      Uri.parse(
                        'https://wiki.archethic.net/category/FAQ',
                      ),
                    );
                    break;
                  default:
                }
              },
              selectedIndex: navDrawerIndex,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                  child: Text(
                    'Hosting',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...destinationsHosting.map((destination) {
                  return NavigationDrawerDestination(
                    label: Text(destination.label),
                    icon: destination.icon,
                    selectedIcon: destination.icon,
                  );
                }),
                Expanded(
                  child: Container(
                    width: 50,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                  child: Text(
                    'Informations',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...destinationsInfos.map((destination) {
                  return NavigationDrawerDestination(
                    label: Text(destination.label),
                    icon: destination.icon,
                    selectedIcon: destination.icon,
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final asyncVersionString = ref.watch(
                versionStringProvider(
                  AppLocalizations.of(context)!,
                ),
              );
              return Text(
                asyncVersionString.asData?.value ?? '',
                style: Theme.of(context).textTheme.labelSmall,
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: ConnectionToWalletStatus(),
        )
      ],
    );
  }
}
