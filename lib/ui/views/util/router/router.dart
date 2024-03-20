import 'package:aeweb/ui/views/add_website/layouts/add_website_sheet.dart';
import 'package:aeweb/ui/views/display_website/explorer_files.dart';
import 'package:aeweb/ui/views/display_website/explorer_tx.dart';
import 'package:aeweb/ui/views/main_screen/layouts/main_screen.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/unpublish_website_sheet.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/update_certificate_sheet.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/update_website_sync_sheet.dart';
import 'package:aeweb/ui/views/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: WelcomeScreen.routerPage,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: WelcomeScreen.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: WelcomeScreen(),
            );
          },
        ),
        GoRoute(
          path: MainScreen.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: MainScreen(),
            );
          },
        ),
        GoRoute(
          path: AddWebsiteSheet.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: AddWebsiteSheet(),
            );
          },
        ),
        /* GoRoute(
          path: ExplorerFilesScreen.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: ExplorerFilesScreen(),
            );
          },
        ),
        GoRoute(
          path: ExplorerTxScreen.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: ExplorerTxScreen(),
            );
          },
        ),
        GoRoute(
          path: UpdateCertificateSheet.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: UpdateCertificateSheet(),
            );
          },
        ),
        GoRoute(
          path: UnpublishWebsiteSheet.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: UnpublishWebsiteSheet(),
            );
          },
        ),
        GoRoute(
          path: UpdateWebsiteSyncSheet.routerPage,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: UpdateWebsiteSyncSheet(),
            );
          },
        ),*/
      ],
      redirect: (context, state) async {
        return null;
      },
      errorBuilder: (context, state) => const WelcomeScreen(),
    );
  },
);
