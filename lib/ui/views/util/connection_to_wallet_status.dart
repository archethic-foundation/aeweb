import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/icon_close_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';

class ConnectionToWalletStatus extends ConsumerStatefulWidget {
  const ConnectionToWalletStatus({
    super.key,
  });

  @override
  ConsumerState<ConnectionToWalletStatus> createState() =>
      _ConnectionToWalletStatusState();
}

class _ConnectionToWalletStatusState
    extends ConsumerState<ConnectionToWalletStatus> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final session = ref.watch(SessionProviders.session);

    if (session.oldNameAccount.isNotEmpty &&
        session.oldNameAccount != session.nameAccount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              AppLocalizations.of(context)!.changeCurrentAccountWarning,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        ref.read(SessionProviders.session.notifier).setOldNameAccount();

        ref
          ..invalidate(WebsitesProviders.fetchWebsites)
          ..invalidate(WebsitesProviders.fetchWebsiteVersions);
      });
    }

    return session.isConnected
        ? DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.background.withOpacity(1),
                  Theme.of(context).colorScheme.background.withOpacity(0.3),
                ],
                stops: const [0, 1],
              ),
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(0.5),
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
                  ],
                  stops: const [0, 1],
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          session.nameAccount,
                          style: textTheme.labelMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
                        child: Text(
                          session.endpoint,
                          style: textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const IconCloseConnection(),
                ],
              ),
            ),
          )
        : AppButton(
            labelBtn: AppLocalizations.of(context)!.btn_connect_wallet,
            onPressed: () async {
              final sessionNotifier =
                  ref.watch(SessionProviders.session.notifier);
              await sessionNotifier.connectToWallet();

              if (ref.read(SessionProviders.session).error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:
                        Theme.of(context).snackBarTheme.backgroundColor,
                    content: Text(
                      ref.read(SessionProviders.session).error,
                      style: Theme.of(context).snackBarTheme.contentTextStyle,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          );
  }
}
