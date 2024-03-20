/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:ui';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/add_website/layouts/add_website_sheet.dart';
import 'package:aeweb/ui/views/main_screen/layouts/app_bar.dart';
import 'package:aeweb/ui/views/main_screen/layouts/body.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  static const routerPage = '/main';

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AeWebThemeBase.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const AppBarMainScreen(),
          ),
        ),
      ),
      body: const Stack(
        alignment: Alignment.topCenter,
        children: [
          AEWebBackground(),
          Body(),
        ],
      ),
      floatingActionButton: session.isConnected
          ? FloatingActionButton.extended(
              onPressed: () {
                context.go(AddWebsiteSheet.routerPage);
              },
              icon: const Icon(Icons.add),
              label: Text(
                AppLocalizations.of(context)!.addWebsite,
              ),
            )
          : null,
    );
  }
}
