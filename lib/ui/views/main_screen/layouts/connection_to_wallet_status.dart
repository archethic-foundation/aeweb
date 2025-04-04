/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/app_embedded.dart';
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/util/components/format_address_link_copy.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final session = ref.watch(sessionNotifierProvider);
    final isAppEmbedded = ref.watch(isAppEmbeddedProvider);

    ref.listen(sessionNotifierProvider, (previous, next) {
      if (!mounted) return;

      if (previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: SelectableText(
              next.error,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (previous != null &&
          previous.nameAccount.isNotEmpty &&
          next.nameAccount != previous.nameAccount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: SelectableText(
              AppLocalizations.of(context)!.changeCurrentAccountWarning,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        context.go(RoutesPath().home());
      }
    });

    if (session.isConnected == false) {
      if (aedappfm.Responsive.isMobile(context) == false) {
        return InkWell(
          onTap: ref.read(sessionNotifierProvider.notifier).connectWallet,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) =>
                aedappfm.AppThemeBase.gradientWelcomeTxt.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              AppLocalizations.of(context)!.btn_connect_wallet,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            aedappfm.Iconsax.user,
            size: 18,
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  session.nameAccount,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Flexible(
                child: FormatAddressLinkCopy(
                  address: session.genesisAddress.toUpperCase(),
                  typeAddress: TypeAddressLinkCopy.chain,
                  reduceAddress: true,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (isAppEmbedded == false)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                IconButton(
                  icon: const Icon(aedappfm.Iconsax.logout),
                  iconSize: 18,
                  onPressed: () async {
                    await ref
                        .read(sessionNotifierProvider.notifier)
                        .cancelConnection();
                  },
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
