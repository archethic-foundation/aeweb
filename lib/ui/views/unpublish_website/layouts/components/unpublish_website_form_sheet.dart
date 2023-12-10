import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
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
        const AEWebBackground(),
        Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 5,
            right: 5,
          ),
          child: ArchethicScrollbar(
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
                          Iconsax.warning_2,
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
