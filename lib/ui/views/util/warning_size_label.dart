import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarningSizeLabel extends ConsumerWidget {
  const WarningSizeLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (FeatureFlags.websiteSizeLimit == false) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Iconsax.info_circle,
              color: Colors.yellow,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              AppLocalizations.of(context)!.informations,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        Text(
          AppLocalizations.of(context)!.betaVersionMaxFiles,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
