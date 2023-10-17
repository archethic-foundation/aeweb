/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/hive/db_helper.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:aeweb/util/generic/providers_observer.dart';
import 'package:aeweb/util/service_locator.dart';
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(reddwarf03): use LanguageProviders
    //const language = AvailableLanguage.english;

    // GoRouter configuration
    final _router = GoRouter(
      routes: RoutesPath().aeWebRoutes(ref),
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'AEWeb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Lato',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Lato',
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
