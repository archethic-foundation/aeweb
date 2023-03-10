/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aeweb/localization.dart';
import 'package:aeweb/model/available_language.dart';
import 'package:aeweb/model/data/appdb.dart';
import 'package:aeweb/providers_observer.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.setupDatabase();
  setupServiceLocator();

  final endpointResponse = await sl.get<ArchethicDAppClient>().getEndpoint();
  var endpointUrl = '';
  endpointResponse.when(
    failure: (failure) {
      log(
        'Transaction failed',
        error: failure,
      );
    },
    success: (result) {
      endpointUrl = result.endpointUrl;
      log(
        'Transaction succeed : ${json.encode(result)}',
      );
    },
  );

  runApp(
    ProviderScope(
      observers: [
        ProvidersLogger(),
      ],
      child: MyApp(
        endpoint: endpointUrl,
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
    const language = AvailableLanguage.french;

    return MaterialApp(
      title: 'AEWeb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFFFFFFF),
        fontFamily: 'Montserrat',
        brightness: Brightness.dark,
      ),
      localizationsDelegates: const [
        AppLocalizationsDelegate(language),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: WebsiteList(title: 'AEWeb - $endpoint'),
      onGenerateRoute: (settings) {
        if ((sl.get<ArchethicDAppClient>() as DeeplinkArchethicDappClient)
            .handleRoute(settings.name)) return;

        //... do everything else needed by your application
        return null;
      },
    );
  }
}
