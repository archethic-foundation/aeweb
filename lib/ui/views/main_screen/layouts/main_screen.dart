/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:ui';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/main_screen/layouts/app_bar.dart';
import 'package:aeweb/ui/views/main_screen/layouts/body.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:aeweb/ui/views/util/components/aeweb_main_menu_app.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: AeWebThemeBase.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBarMainScreen(
                onAEMenuTapped: _toggleSubMenu,
              ),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            const AEWebBackground(),
            const Body(),
            if (_isSubMenuOpen) const AEWebMainMenuApp(),
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
    );
  }
}
