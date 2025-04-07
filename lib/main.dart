/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:aeweb/util/generic/providers_observer.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.setupDatabase();
  setupServiceLocator();
  runApp(
    ProviderScope(
      observers: [
        ProvidersLogger(),
      ],
      child: const ProvidersInitialization(child: MyApp()),
    ),
  );
}

/// Eagerly initializes providers (https://riverpod.dev/docs/essentials/eager_initialization).
///
/// Add Watch here for any provider you want to init when app is displayed.
/// Those providers will be kept alive during application lifetime.
class ProvidersInitialization extends ConsumerWidget {
  const ProvidersInitialization({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sessionNotifierProvider);
    return child;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  ConsumerState<MyApp> createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    unawaited(
      ref
          .read(
            aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.notifier,
          )
          .startSubscription(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GoRouter configuration
    final _router = GoRouter(
      routes: RoutesPath().aeWebRoutes(ref),
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'aeHosting',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'PPTelegraf',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'PPTelegraf',
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        aedappfm.AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
