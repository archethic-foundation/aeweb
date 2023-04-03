import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/main_screen.dart';
import 'package:aeweb/ui/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteScreen extends ConsumerWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(SessionProviders.session);

    if (session.isConnectedToWallet) {
      return const MainScreen();
    }

    return const WelcomeScreen();
  }
}
