import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnpublishWebsiteFormSheet extends ConsumerWidget {
  const UnpublishWebsiteFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Stack(
      children: [
        const aedappfm.AppBackground(
          backgroundImage: 'assets/images/background-welcome.png',
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 5,
            right: 5,
          ),
          child: aedappfm.ArchethicScrollbar(
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 100),
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          aedappfm.Iconsax.warning_2,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          AppLocalizations.of(context)!.disclaimer,
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.unpublishWebSiteDesc,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
