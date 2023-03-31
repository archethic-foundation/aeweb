import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDestination {
  const MenuDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<MenuDestination> destinationsHosting = <MenuDestination>[
  MenuDestination(
    'Your websites',
    Icon(Icons.cloud_circle_outlined),
    Icon(Icons.cloud_circle),
  ),
  MenuDestination(
    'New website',
    Icon(Icons.add_circle_outline),
    Icon(Icons.add_circle),
  ),
];

const List<MenuDestination> destinationsInfos = <MenuDestination>[
  MenuDestination(
    'Documentation',
    Icon(Icons.feed_outlined),
    Icon(Icons.feed),
  ),
  MenuDestination(
    'Source Code',
    Icon(Icons.code_outlined),
    Icon(Icons.code),
  ),
  MenuDestination(
    'FAQ',
    Icon(Icons.help_outlined),
    Icon(Icons.help_outline),
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
    return NavigationDrawer(
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
                'https://archethic-foundation.github.io/archethic-docs/participate/aeweb',
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
                'https://archethic-foundation.github.io/archethic-docs/category/FAQ',
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
            selectedIcon: destination.selectedIcon,
          );
        }),
        const Divider(indent: 28, endIndent: 28),
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
            selectedIcon: destination.selectedIcon,
          );
        }),
      ],
    );
  }
}
