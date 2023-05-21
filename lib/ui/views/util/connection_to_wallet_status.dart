import 'dart:math';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';

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
  bool _over = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final session = ref.watch(SessionProviders.session);
    final sessionNotifier = ref.watch(SessionProviders.session.notifier);

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

    return session.isConnectedToWallet == false
        ? MouseRegion(
            onEnter: (_) {
              setState(() {
                _over = true;
              });
            },
            onExit: (_) {
              setState(() {
                _over = false;
              });
            },
            child: OutlinedButton(
              style: ButtonStyle(
                side: MaterialStateProperty.all(BorderSide.none),
              ),
              onPressed: () async {
                await sessionNotifier.connectToWallet();

                if (session.error.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          Theme.of(context).snackBarTheme.backgroundColor,
                      content: Text(
                        session.error,
                        style: Theme.of(context).snackBarTheme.contentTextStyle,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0xFF00A4DB),
                      Color(0xFFCC00FF),
                    ],
                    transform: GradientRotation(pi / 9),
                  ),
                  shape: const StadiumBorder(),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 7,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.empty_wallet,
                      color: Theme.of(context).textTheme.labelMedium!.color,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.connectionWalletConnect,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelMedium!.color,
                        fontFamily: 'Equinox',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ).animate(target: _over ? 0 : 1).fade(end: 0.8),
            ),
          )
        : DecoratedBox(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.empty_wallet_tick,
                        color: Colors.green,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.nameAccount,
                        style: textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                IconButtonAnimated(
                  onPressed: () async {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return ScaffoldMessenger(
                          child: Builder(
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                content: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .confirmationPopupTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .connectionWalletDisconnectWarning,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                          bottom: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AppButton(
                                              labelBtn:
                                                  AppLocalizations.of(context)!
                                                      .no,
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            AppButton(
                                              labelBtn:
                                                  AppLocalizations.of(context)!
                                                      .yes,
                                              onPressed: () async {
                                                await sessionNotifier
                                                    .cancelConnection();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.power_settings_new_rounded),
                  color: Colors.red,
                  tooltip:
                      AppLocalizations.of(context)!.connectionWalletDisconnect,
                ),
              ],
            ),
          );
  }
}
