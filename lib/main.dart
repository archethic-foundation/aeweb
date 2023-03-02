/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aeweb/localization.dart';
import 'package:aeweb/model/available_language.dart';
import 'package:aeweb/model/data/appdb.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/providers_observer.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:aeweb/util/service_locator.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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

  if (!kIsWeb && Platform.isAndroid) {
    // Fix LetsEncrypt root certificate for Android<7.1
    final x1cert = await rootBundle.load('assets/ssl/isrg-root-x1.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(
      x1cert.buffer.asUint8List(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MyHomePage(title: 'AEWeb'),
      onGenerateRoute: (settings) {
        if ((sl.get<ArchethicDAppClient>() as DeeplinkArchethicDappClient)
            .handleRoute(settings.name)) return;

        //... do everything else needed by your application
        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Website> _websites = [
    const Website(
      name: 'Example',
      genesisAddress: '00008900FA...234BCA',
      size: '12.3',
      nbTransactions: '5',
      lastPublicationFees: '2.34 UCO',
      globalFees: '13.45 UCO',
    ),
    const Website(
      name: 'Uniris.io',
      genesisAddress: '000076FFA0...45B56',
      size: '20.0',
      nbTransactions: '75',
      lastPublicationFees: '6.23 UCO',
      globalFees: '6.23 UCO',
    ),
    const Website(
      name: 'Archethic.net',
      genesisAddress: '0000D318820...43134',
      size: '30.5',
      nbTransactions: '12',
      lastPublicationFees: '14.39 UCO',
      globalFees: '14.39 UCO',
    ),
  ];

  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AEWeb'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: _isGrid ? _buildGrid() : _buildList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, color: Colors.white),
          label: 'Documentation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gavel, color: Colors.white),
          label: 'Terms of Use',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.privacy_tip, color: Colors.white),
          label: 'Privacy Policy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code, color: Colors.white),
          label: 'Source Code',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help_outline, color: Colors.white),
          label: 'FAQ',
        ),
      ],
      onTap: (int index) {
        String? url;
        switch (index) {
          case 0:
            url =
                'https://archethic-foundation.github.io/archethic-docs/participate/aeweb';
            break;
          case 1:
            url = '#';
            break;
          case 2:
            url = '#';
            break;
          case 3:
            url = 'https://github.com/archethic-foundation/aeweb';
            break;
          case 4:
            url =
                'https://archethic-foundation.github.io/archethic-docs/category/FAQ';
            break;
        }
        if (url != null) {
          launchUrl(Uri.parse(url));
        }
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _websites.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        return _buildWebsiteCard(_websites[index]);
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _websites.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeaderRow();
        }
        return _buildWebsiteRow(_websites[index - 1]);
      },
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.grey[800],
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: const [
          Expanded(child: Text('Name')),
          Expanded(child: Text('Genesis Address')),
          Expanded(child: Text('Size (Mo)')),
          Expanded(child: Text('Nb of Transactions')),
          Expanded(child: Text('Last Publication Fees')),
          Expanded(child: Text('Global Fees')),
        ],
      ),
    );
  }

  Widget _buildWebsiteRow(Website website) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(child: Text(website.name)),
          Expanded(child: Text(website.genesisAddress)),
          Expanded(child: Text(website.size)),
          Expanded(child: Text(website.nbTransactions)),
          Expanded(child: Text(website.lastPublicationFees)),
          Expanded(child: Text(website.globalFees)),
          _popupMenuButton(),
        ],
      ),
    );
  }

  Future<void> _sendTx() async {
    const content = '''
{
  "aewebVersion": 1,
  "hashFunction": "sha1",
  "metaData": {
    "index.html": {
      "addresses": ["0000808d370648759d681c4cf72c32851e3e23bf59c412e1a6251a80f6dd17160231"],
      "encoding": "gzip",
      "size": 10000,
      "hash": "682df00e5daf5e76a0d1d73839e8bde840ee3ab9"
    }
  } 
}
''';

    final transaction =
        Transaction(type: 'hosting', data: Transaction.initData())
            .setContent(content);

    final response = await sl
        .get<ArchethicDAppClient>()
        .sendTransaction(transaction.toJson());
    response.when(
      failure: (failure) {
        log(
          'Transaction failed',
          error: failure,
        );
        var message = 'An error occured';
        switch (failure.code) {
          case 4901:
            message = 'Please, connect your Archethic wallet';
            break;
          default:
            message = failure.message ?? 'An error occured';
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      },
      success: (result) {
        log(
          'Transaction succeed : ${json.encode(result)}',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json.encode(result)),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _popupMenuButton() {
    return PopupMenuButton(
      constraints: const BoxConstraints.expand(width: 300, height: 250),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'SendTransaction',
            onTap: _sendTx,
            child: Row(
              children: const [
                Icon(Icons.send),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Send Transaction'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Explore',
            child: Row(
              children: const [
                Icon(Icons.explore),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Explore'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Upload',
            child: Row(
              children: const [
                Icon(Icons.cloud_upload),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Upload'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            child: Row(
              children: const [
                Icon(Icons.delete),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Delete files and SSL certificate / key'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Download',
            child: Row(
              children: const [
                Icon(Icons.download),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Download'),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Certificate',
            child: Row(
              children: const [
                Icon(Icons.security),
                SizedBox(width: 8),
                Flexible(
                  child: Text('Certificate management'),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildWebsiteCard(Website website) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/${website.name}.png'),
            ),
            const SizedBox(height: 16),
            Text(
              website.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              website.genesisAddress,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Size (Mo): ${website.size}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Nb of Transactions: ${website.nbTransactions}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Last Publication Fees: ${website.lastPublicationFees}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Global Fees: ${website.globalFees}',
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            _popupMenuButton(),
          ],
        ),
      ),
    );
  }
}
