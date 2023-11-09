/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/main_screen/bloc/provider.dart';
import 'package:aeweb/ui/views/main_screen/layouts/app_bar.dart';
import 'package:aeweb/ui/views/main_screen/layouts/body.dart';
import 'package:aeweb/ui/views/util/components/main_background.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:busy/busy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  bool _isSubMenuOpen = false;

  void _toggleSubMenu() {
    setState(() {
      _isSubMenuOpen = !_isSubMenuOpen;
    });
    return;
  }

  void _closeSubMenu() {
    setState(() {
      _isSubMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);

    return GestureDetector(
      onTap: _closeSubMenu,
      child: BusyScaffold(
        isBusy: ref.watch(isLoadingMainScreenProvider),
        scaffold: Scaffold(
          backgroundColor: AeWebThemeBase.backgroundColor,
          appBar: AppBarMainScreen(
            onAEMenuTapped: _toggleSubMenu,
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              const MainBackground(),
              const Body(),
              if (_isSubMenuOpen)
                Positioned(
                  top: 0,
                  right: 20,
                  child: Column(
                    children: [
                      _buildSubMenu(
                        topPadding: 10,
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuDEXItem,
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuDEXDesc,
                        'https://aeweb.archethic.net',
                      )
                          .animate(delay: 100.ms)
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .move(
                            begin: const Offset(-16, 0),
                            curve: Curves.easeOutQuad,
                          ),
                      _buildSubMenu(
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuBridgeItem,
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuBridgeDesc,
                        'https://bridge.archethic.net',
                      )
                          .animate(delay: 300.ms)
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .move(
                            begin: const Offset(-16, 0),
                            curve: Curves.easeOutQuad,
                          ),
                      _buildSubMenu(
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuWalletOnWayItem,
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuWalletOnWayDesc,
                        'https://www.archethic.net/wallet',
                      )
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .move(
                            begin: const Offset(-16, 0),
                            curve: Curves.easeOutQuad,
                          ),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButton: session.isConnected
              ? FloatingActionButton.extended(
                  onPressed: () {
                    context.go(RoutesPath().addWebsite());
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    AppLocalizations.of(context)!.addWebsite,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSubMenu(
    String label,
    String description,
    String url, {
    double topPadding = 20,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: InkWell(
        onTap: () {
          launchUrl(
            Uri.parse(url),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                ArchethicThemeBase.blue800,
                BlendMode.modulate,
              ),
              image: const AssetImage(
                'assets/images/background-sub-menu.png',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: ArchethicThemeBase.neutral900,
                blurRadius: 40,
                spreadRadius: 10,
                offset: const Offset(1, 10),
              ),
            ],
          ),
          width: 250,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    description,
                    textAlign: TextAlign.end,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
