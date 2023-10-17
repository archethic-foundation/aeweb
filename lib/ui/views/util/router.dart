import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/model/website_version_tx.dart';
import 'package:aeweb/ui/views/add_website/layouts/add_website_sheet.dart';
import 'package:aeweb/ui/views/display_website/explorer_files.dart';
import 'package:aeweb/ui/views/display_website/explorer_tx.dart';
import 'package:aeweb/ui/views/display_website/website_versions_list.dart';
import 'package:aeweb/ui/views/main_screen/layouts/main_screen.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/update_certificate_sheet.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/update_website_sync_sheet.dart';
import 'package:aeweb/ui/views/welcome/welcome_screen.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutesPath {
  factory RoutesPath() {
    return _singleton;
  }

  RoutesPath._internal();
  static final RoutesPath _singleton = RoutesPath._internal();

  final String websiteNameParameter = 'websiteName';

  String home() {
    return '/';
  }

  String main() {
    return '/aeweb/websites';
  }

  String welcome() {
    return '/welcome';
  }

  String addWebsite() {
    return '${main()}/add_website';
  }

  String _addWebsite() {
    return 'add_website';
  }

  String websiteDetails(String websiteName) {
    return '${main()}/$websiteName/details';
  }

  String _websiteDetails() {
    return ':$websiteNameParameter/details';
  }

  String exploreFiles(String websiteName) {
    return '${main()}/$websiteName/files';
  }

  String _exploreFiles() {
    return ':$websiteNameParameter/files';
  }

  String exploreTransactions(String websiteName) {
    return '${main()}/$websiteName/transactions';
  }

  String _exploreTransactions() {
    return ':$websiteNameParameter/transactions';
  }

  String updateCert(String websiteName) {
    return '${main()}/$websiteName/update_cert';
  }

  String _updateCert() {
    return ':$websiteNameParameter/update_cert';
  }

  String unpublishWebsite(String websiteName) {
    return '${main()}/$websiteName/unpublish';
  }

  String _unpublishWebsite() {
    return ':$websiteNameParameter/unpublish';
  }

  String updateWebsiteSync(String websiteName) {
    return '${main()}/$websiteName/update_sync';
  }

  String _updateWebsiteSync() {
    return ':$websiteNameParameter/update_sync';
  }

  List<RouteBase> aeWebRoutes(WidgetRef ref) {
    return <RouteBase>[
      GoRoute(
        path: RoutesPath().home(),
        builder: (BuildContext context, GoRouterState state) {
          final session = ref.read(SessionProviders.session);

          if (session.isConnected) {
            return const MainScreen();
          }

          return const WelcomeScreen();
        },
      ),
      GoRoute(
        path: RoutesPath().welcome(),
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeScreen();
        },
      ),
      GoRoute(
        path: RoutesPath().main(),
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
        },
        routes: [
          GoRoute(
            path: _addWebsite(),
            builder: (context, state) {
              return const AddWebsiteSheet();
            },
          ),
          GoRoute(
            path: _websiteDetails(),
            builder: (context, state) {
              final args = state.extra! as Map<String, Object?>;
              final pathParameter = state.pathParameters;

              return WebsiteVersionsList(
                websiteName: pathParameter[websiteNameParameter]!,
                genesisAddress: args['genesisAddress'] == null
                    ? ''
                    : args['genesisAddress']! as String,
              );
            },
          ),
          GoRoute(
            path: _exploreFiles(),
            builder: (context, state) {
              final args = state.extra! as Map<String, Object?>;

              return ExplorerFilesScreen(
                filesAndFolders: args['filesAndFolders'] == null
                    ? {}
                    : args['filesAndFolders']!
                        as Map<String, HostingRefContentMetaData>,
              );
            },
          ),
          GoRoute(
            path: _exploreTransactions(),
            builder: (context, state) {
              final args = state.extra! as Map<String, Object?>;

              return ExplorerTxScreen(
                websiteVersionTxList: args['websiteVersionTxList'] == null
                    ? []
                    : args['websiteVersionTxList']! as List<WebsiteVersionTx>,
              );
            },
          ),
          GoRoute(
            path: _updateCert(),
            builder: (context, state) {
              final pathParameter = state.pathParameters;

              return UpdateCertificateSheet(
                websiteName: pathParameter[websiteNameParameter]!,
              );
            },
          ),
          GoRoute(
            path: _unpublishWebsite(),
            builder: (context, state) {
              final pathParameter = state.pathParameters;

              return UpdateCertificateSheet(
                websiteName: pathParameter[websiteNameParameter]!,
              );
            },
          ),
          GoRoute(
            path: _updateWebsiteSync(),
            builder: (context, state) {
              final args = state.extra! as Map<String, Object?>;
              final pathParameter = state.pathParameters;

              return UpdateWebsiteSyncSheet(
                websiteName: pathParameter[websiteNameParameter]!,
                path: args['path'] == null ? '' : args['path']! as String,
                zipFile: args['zipFile'] == null
                    ? Uint8List.fromList([])
                    : args['zipFile']! as Uint8List,
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
      ),
    ];
  }
}
