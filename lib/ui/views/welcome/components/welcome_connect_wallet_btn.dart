import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeConnectWalletBtn extends StatelessWidget {
  const WelcomeConnectWalletBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 300,
            child: ConnectionToWalletStatus(),
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
