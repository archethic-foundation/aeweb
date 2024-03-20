import 'dart:ui';

import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/main_screen/layouts/app_bar_welcome.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_connect_wallet_btn.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  static const routerPage = '/welcome';

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AeWebThemeBase.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const AppBarWelcome(),
          ),
        ),
      ),
      body: const Stack(
        children: [
          AEWebBackground(withAnimation: true),
          Column(
            children: [
              WelcomeTitle(),
              WelcomeConnectWalletBtn(),
            ],
          ),
        ],
      ),
    );
  }
}
