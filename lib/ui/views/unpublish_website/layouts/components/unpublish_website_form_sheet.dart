import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';

class UnpublishWebsiteFormSheet extends ConsumerWidget {
  const UnpublishWebsiteFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0x003C89B9),
              Color(0xFFCC00FF),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Iconsax.warning_2,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!.disclaimer,
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.unpublishWebSiteDesc,
                style: textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
