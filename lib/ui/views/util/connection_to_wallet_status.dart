import 'package:aeweb/application/session/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final sessionNotifier = ref.watch(SessionProviders.session.notifier);

    return session.isConnectedToWallet == false
        ? OutlinedButton(
            onPressed: () async {
              await sessionNotifier.connectToWallet();

              if (session.error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      session.error,
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Row(
              children: [
                const Icon(
                  Icons.blur_circular,
                  color: Colors.red,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text('Connect your wallet', style: textTheme.labelMedium),
              ],
            ),
          )
        : OutlinedButton(
            onPressed: () {},
            child: Row(
              children: [
                const Icon(
                  Icons.blur_circular,
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
          );
  }
}
