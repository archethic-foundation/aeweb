import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/application/session/state.dart';
import 'package:aeweb/application/version.dart';
import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/util/header.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDestination {
  const MenuDestination(
    this.label,
    this.icon,
    this.externalLink, {
    this.readOnly = false,
  });

  final String label;
  final Widget icon;
  final bool externalLink;
  final bool readOnly;
}

class NavigationDrawerSection extends ConsumerStatefulWidget {
  const NavigationDrawerSection({super.key});

  @override
  ConsumerState<NavigationDrawerSection> createState() =>
      _NavigationDrawerSectionState();
}

class _NavigationDrawerSectionState
    extends ConsumerState<NavigationDrawerSection> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);

    return Column(
      children: [
        const Header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: Responsive.isDesktop(context)
                ? NavigationDrawer(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onDestinationSelected: (selectedIndex) {
                      setState(() {
                        navDrawerIndex = selectedIndex;
                      });
                      _manageLink(session, selectedIndex);
                    },
                    selectedIndex: navDrawerIndex,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                        child: Text(
                          AppLocalizations.of(context)!.menu_section_hosting,
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ...<MenuDestination>[
                        MenuDestination(
                          AppLocalizations.of(context)!.menu_websitesList,
                          const Icon(Iconsax.global),
                          false,
                        ),
                        if (session.isConnected)
                          MenuDestination(
                            AppLocalizations.of(context)!.menu_addWebsite,
                            const Icon(Iconsax.add_circle),
                            false,
                          ),
                      ].map((destination) {
                        return NavigationDrawerDestination(
                          label: destination.externalLink
                              ? Row(
                                  children: [
                                    Text(
                                      destination.label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Iconsax.export_3,
                                      size: 12,
                                    ),
                                  ],
                                )
                              : Text(destination.label),
                          icon: destination.icon,
                          selectedIcon: destination.icon,
                        );
                      }),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
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
                      const SizedBox(
                        height: 5,
                      ),
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                          child: Text(
                            AppLocalizations.of(context)!.menu_section_infos,
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ...<MenuDestination>[
                        MenuDestination(
                          AppLocalizations.of(context)!.menu_documentation,
                          const Icon(Iconsax.document_text),
                          true,
                        ),
                        MenuDestination(
                          AppLocalizations.of(context)!.menu_sourceCode,
                          const Icon(Iconsax.code_circle),
                          true,
                        ),
                        MenuDestination(
                          AppLocalizations.of(context)!.menu_faq,
                          const Icon(Iconsax.message_question),
                          true,
                        ),
                        MenuDestination(
                          AppLocalizations.of(context)!.menu_tuto,
                          const Icon(Iconsax.video_play),
                          true,
                        ),
                        MenuDestination(
                          AppLocalizations.of(context)!.menu_report_bug,
                          const Icon(Iconsax.reserve),
                          true,
                        ),
                      ].map((destination) {
                        return Responsive.isDesktop(context)
                            ? NavigationDrawerDestination(
                                label: destination.externalLink
                                    ? Row(
                                        children: [
                                          Text(
                                            destination.label,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Iconsax.export_3,
                                            size: 12,
                                          ),
                                        ],
                                      )
                                    : Text(destination.label),
                                icon: destination.icon,
                                selectedIcon: destination.icon,
                              )
                            : NavigationDrawerDestination(
                                label: const SizedBox(),
                                icon: destination.icon,
                                selectedIcon: destination.icon,
                              );
                      }),
                    ],
                  )
                : NavigationRail(
                    backgroundColor: Colors.transparent,
                    destinations: [
                      const NavigationRailDestination(
                        label: SizedBox(),
                        icon: Icon(Iconsax.global),
                      ),
                      if (session.isConnected)
                        const NavigationRailDestination(
                          label: SizedBox(),
                          icon: Icon(Iconsax.add_circle),
                        ),
                      const NavigationRailDestination(
                        label: SizedBox(),
                        icon: Icon(Iconsax.document_text),
                      ),
                      const NavigationRailDestination(
                        label: SizedBox(),
                        icon: Icon(Iconsax.code_circle),
                      ),
                      const NavigationRailDestination(
                        label: SizedBox(),
                        icon: Icon(Iconsax.message_question),
                      ),
                      const NavigationRailDestination(
                        label: SizedBox(),
                        icon: Icon(Iconsax.video_play),
                      ),
                    ],
                    selectedIndex: navDrawerIndex,
                    onDestinationSelected: (selectedIndex) {
                      setState(() {
                        navDrawerIndex = selectedIndex;
                      });
                      _manageLink(session, selectedIndex);
                    },
                  ),
          ),
        ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/AELogo-Public Blockchain-White.svg',
                  semanticsLabel: 'AE Logo',
                  height: 18,
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer(
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
              ],
            ),
          ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: ConnectionToWalletStatus(),
        )
      ],
    );
  }

  void _manageLink(Session session, int selectedIndex) {
    if (session.isConnected) {
      _manageLinkConnected(selectedIndex);
    } else {
      _manageLinkNotConnected(selectedIndex);
    }
  }

  void _manageLinkConnected(int selectedIndex) {
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
      case 5:
        launchUrl(
          Uri.parse(
            'https://wiki.archethic.net/participate/aeweb/usage/aeweb-front',
          ),
        );
        break;
      case 6:
        launchUrl(
          Uri.parse(
            'https://github.com/archethic-foundation/aeweb/issues/new?assignees=&labels=bug&projects=&template=bug_report.yml',
          ),
        );
        break;
      default:
    }
  }

  void _manageLinkNotConnected(int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        launchUrl(
          Uri.parse(
            'https://wiki.archethic.net/participate/aeweb/',
          ),
        );
        break;
      case 2:
        launchUrl(
          Uri.parse(
            'https://github.com/archethic-foundation/aeweb',
          ),
        );
        break;
      case 3:
        launchUrl(
          Uri.parse(
            'https://wiki.archethic.net/category/FAQ',
          ),
        );
        break;
      case 4:
        launchUrl(
          Uri.parse(
            'https://wiki.archethic.net/participate/aeweb/usage/aeweb-front',
          ),
        );
        break;
      case 5:
        launchUrl(
          Uri.parse(
            'https://github.com/archethic-foundation/aeweb/issues/new?assignees=&labels=bug&projects=&template=bug_report.yml',
          ),
        );
        break;
      default:
    }
  }
}
