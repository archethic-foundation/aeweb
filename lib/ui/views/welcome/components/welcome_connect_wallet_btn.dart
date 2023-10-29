/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:aeweb/ui/views/welcome/bloc/providers.dart';
import 'package:busy/busy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeConnectWalletBtn extends ConsumerStatefulWidget {
  const WelcomeConnectWalletBtn({
    super.key,
  });
  @override
  WelcomeConnectWalletBtnState createState() => WelcomeConnectWalletBtnState();
}

var _over = false;

class WelcomeConnectWalletBtnState
    extends ConsumerState<WelcomeConnectWalletBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: MouseRegion(
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
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  startBusyContext(
                    () async {
                      final sessionNotifier =
                          ref.read(SessionProviders.session.notifier);
                      await sessionNotifier.connectToWallet();

                      final session = ref.read(SessionProviders.session);
                      if (session.error.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                Theme.of(context).snackBarTheme.backgroundColor,
                            content: Text(
                              session.error,
                              style: Theme.of(context)
                                  .snackBarTheme
                                  .contentTextStyle,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        context.go(RoutesPath().main());
                      }
                    },
                    isBusyValueChanged: (isBusy) {
                      ref.read(isLoadingWelcomeScreenProvider.notifier).state =
                          isBusy;
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: ShapeDecoration(
                    gradient: AeWebThemeBase.gradientBtn,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ).animate(target: _over ? 0 : 1).fade(end: 0.8),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              launchUrl(
                Uri.parse(
                  'https://www.archethic.net/aewallet.html',
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                AppLocalizations.of(context)!.welcomeNoWallet,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
