import 'package:aeweb/application/version.dart';
import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/util/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDestination {
  const MenuDestination(this.label, this.icon, this.externalLink);

  final String label;
  final Widget icon;
  final bool externalLink;
}

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
                    AppLocalizations.of(context)!.menu_section_hosting,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...<MenuDestination>[
                  MenuDestination(
                    AppLocalizations.of(context)!.menu_websitesList,
                    const Icon(Iconsax.global),
                    false,
                  ),
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
                              Text(destination.label),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                  child: Text(
                    AppLocalizations.of(context)!.menu_section_infos,
                    style: Theme.of(context).textTheme.titleSmall,
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
                ].map((destination) {
                  return NavigationDrawerDestination(
                    label: destination.externalLink
                        ? Row(
                            children: [
                              Text(destination.label),
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
              ],
            ),
          ),
        ),
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
}
