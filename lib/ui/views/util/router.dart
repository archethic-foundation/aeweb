import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/application/session/state.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/model/website_version_tx.dart';
import 'package:aeweb/ui/views/add_website/layouts/add_website_sheet.dart';
import 'package:aeweb/ui/views/display_website/explorer_files.dart';
import 'package:aeweb/ui/views/display_website/explorer_tx.dart';
import 'package:aeweb/ui/views/main_screen/layouts/main_screen.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/unpublish_website_sheet.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/update_certificate_sheet.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/update_website_sync_sheet.dart';
import 'package:aeweb/ui/views/welcome/welcome_screen.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionStatusNavigator extends ConsumerWidget {
  const SessionStatusNavigator({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      sessionNotifierProvider,
      (previous, next) => _handleSessionStateChange(context, previous, next),
    );
    return child;
  }

  void _handleSessionStateChange(
    BuildContext context,
    Session? previous,
    Session next,
  ) {
    if (previous == null) return;

    final becameDisconnected = previous.isConnected && !next.isConnected;
    if (becameDisconnected) {
      context.go(RoutesPath().welcome());
      return;
    }

    final becameConnected = next.isConnected && !previous.isConnected;
    final selectedAccountChanged =
        next.isConnected && next.nameAccount != previous.nameAccount;

    if (becameConnected || selectedAccountChanged) {
      context.go(RoutesPath().home());
    }
  }
}

class RoutesPath {
  factory RoutesPath() {
    return _singleton;
  }

  RoutesPath._internal();
  static final RoutesPath _singleton = RoutesPath._internal();

  final String genesisAddressParameter = 'genesisAddress';

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
    return '${main()}/website';
  }

  String _addWebsite() {
    return 'website';
  }

  String exploreFiles(String genesisAddress) {
    return '${main()}/$genesisAddress/files';
  }

  String _exploreFiles() {
    return ':$genesisAddressParameter/files';
  }

  String exploreTransactions(String genesisAddress) {
    return '${main()}/$genesisAddress/transactions';
  }

  String _exploreTransactions() {
    return ':$genesisAddressParameter/transactions';
  }

  String updateCert(String genesisAddress) {
    return '${main()}/$genesisAddress/update_cert';
  }

  String _updateCert() {
    return ':$genesisAddressParameter/update_cert';
  }

  String unpublishWebsite(String genesisAddress) {
    return '${main()}/$genesisAddress/unpublish';
  }

  String _unpublishWebsite() {
    return ':$genesisAddressParameter/unpublish';
  }

  String updateWebsiteSync(String genesisAddress) {
    return '${main()}/$genesisAddress/update_sync';
  }

  String _updateWebsiteSync() {
    return ':$genesisAddressParameter/update_sync';
  }

  List<RouteBase> aeWebRoutes(WidgetRef ref) {
    return <RouteBase>[
      ShellRoute(
        builder: (context, state, child) =>
            SessionStatusNavigator(child: child),
        redirect: (context, state) {
          final session = ref.read(sessionNotifierProvider);

          if (!session.isConnected) {
            return RoutesPath().welcome();
          }

          return null;
        },
        routes: [
          GoRoute(
            path: RoutesPath().home(),
            builder: (BuildContext context, GoRouterState state) {
              return const MainScreen();
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
                        : args['websiteVersionTxList']!
                            as List<WebsiteVersionTx>,
                  );
                },
              ),
              GoRoute(
                path: _updateCert(),
                builder: (context, state) {
                  final args = state.extra! as Map<String, Object?>;

                  return UpdateCertificateSheet(
                    websiteName: args['websiteName'] == null
                        ? ''
                        : args['websiteName']! as String,
                  );
                },
              ),
              GoRoute(
                path: _unpublishWebsite(),
                builder: (context, state) {
                  final args = state.extra! as Map<String, Object?>;

                  return UnpublishWebsiteSheet(
                    websiteName: args['websiteName'] == null
                        ? ''
                        : args['websiteName']! as String,
                  );
                },
              ),
              GoRoute(
                path: _updateWebsiteSync(),
                builder: (context, state) {
                  final args = state.extra! as Map<String, Object?>;

                  return UpdateWebsiteSyncSheet(
                    websiteName: args['websiteName'] == null
                        ? ''
                        : args['websiteName']! as String,
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
                        : args['comparedFiles']!
                            as List<HostingContentComparison>,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
