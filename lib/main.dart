/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:io';

import 'package:aeweb/model/hive/appdb.dart';
import 'package:aeweb/providers_observer.dart';
import 'package:aeweb/ui/views/add_website.dart/layouts/add_website_sheet.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:aeweb/ui/views/website/website_versions_list.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/service_locator.dart';
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
      child: MyApp(
        endpoint: sl.get<ApiService>().endpoint,
      ),
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

class MyApp extends StatelessWidget {
  const MyApp({required this.endpoint, super.key});

  final String endpoint;

  @override
  Widget build(BuildContext context) {
    // TODO(reddwarf03): use LanguageProviders
    //const language = AvailableLanguage.english;

    // GoRouter configuration
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WebsiteList(),
        ),
        GoRoute(
          path: '/addWebsite',
          builder: (context, state) => const AddWebsiteSheet(),
        ),
        GoRoute(
          path: '/websiteVersions/:genesisAddress',
          name: 'websiteVersions',
          builder: (context, state) => WebsiteVersionsList(
            genesisAddress: state.params['genesisAddress'] ?? '',
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'AEWeb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFFFFFFF),
        fontFamily: 'Montserrat',
        brightness: Brightness.dark,
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
