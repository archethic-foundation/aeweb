import 'dart:ui';

import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/main_screen/layouts/app_bar_welcome.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:aeweb/ui/views/util/components/aeweb_main_menu_app.dart';
import 'package:aeweb/ui/views/welcome/bloc/providers.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_connect_wallet_btn.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_title.dart';
import 'package:busy/busy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isSubMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeSubMenu,
      child: BusyScaffold(
        isBusy: ref.watch(isLoadingWelcomeScreenProvider),
        scaffold: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AeWebThemeBase.backgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBarWelcome(
                  onAEMenuTapped: _toggleSubMenu,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              const AEWebBackground(withAnimation: true),
              const Column(
                children: [
                  WelcomeTitle(),
                  WelcomeConnectWalletBtn(),
                ],
              ),
              if (_isSubMenuOpen)
                const AEWebMainMenuApp(
                  withFaucet: false,
                ),
            ],
          ),
        ),
      ),
    );
  }

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
}
