/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:io';

import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/model/hive/appdb.dart';
import 'package:aeweb/providers_observer.dart';
import 'package:aeweb/ui/views/add_website/layouts/add_website_sheet.dart';
import 'package:aeweb/ui/views/main_screen.dart';
import 'package:aeweb/ui/views/route_screen.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/update_website_sync_sheet.dart';
import 'package:aeweb/ui/views/website/explorer.dart';
import 'package:aeweb/ui/views/website/website_versions_list.dart';
import 'package:aeweb/ui/views/welcome_screen.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.setupDatabase();
  await setupServiceLocator();

  runApp(
    ProviderScope(
      observers: [
        ProvidersLogger(),
      ],
      child: const MyApp(),
    ),
  );

  if (!kIsWeb && Platform.isAndroid) {
    // Fix LetsEncrypt root certificate for Android<7.1
    final x1cert = await rootBundle.load('assets/ssl/isrg-root-x1.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(
      x1cert.buffer.asUint8List(),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(reddwarf03): use LanguageProviders
    //const language = AvailableLanguage.english;

    // GoRouter configuration
    final _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const RouteScreen()),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/addWebsite',
          builder: (context, state) => const AddWebsiteSheet(),
        ),
        GoRoute(
          path: '/explorer',
          name: 'explorer',
          builder: (context, state) {
            final args = state.extra! as Map<String, Object?>;
            return ExplorerScreen(
              filesAndFolders: args['filesAndFolders'] == null
                  ? const archethic.HostingRef()
                  : args['filesAndFolders']! as archethic.HostingRef,
            );
          },
        ),
        GoRoute(
          path: '/websiteVersions',
          name: 'websiteVersions',
          builder: (context, state) {
            final args = state.extra! as Map<String, Object>;
            return WebsiteVersionsList(
              genesisAddress: args['genesisAddress'] == null
                  ? ''
                  : args['genesisAddress']! as String,
              websiteName: args['websiteName'] == null
                  ? ''
                  : args['websiteName']! as String,
            );
          },
        ),
        GoRoute(
          path: '/updateWebsiteSync',
          name: 'updateWebsiteSync',
          builder: (context, state) {
            final args = state.extra! as Map<String, Object?>;
            return UpdateWebsiteSyncSheet(
              websiteName: args['websiteName'] == null
                  ? ''
                  : args['websiteName']! as String,
              genesisAddress: args['genesisAddress'] == null
                  ? ''
                  : args['genesisAddress']! as String,
              path: args['path'] == null ? '' : args['path']! as String,
              localFiles: args['localFiles'] == null
                  ? <String, HostingRefContentMetaData>{}
                  : args['localFiles']!
                      as Map<String, HostingRefContentMetaData>,
              comparedFiles: args['comparedFiles'] == null
                  ? <HostingContentComparison>[]
                  : args['comparedFiles']! as List<HostingContentComparison>,
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'AEWeb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
