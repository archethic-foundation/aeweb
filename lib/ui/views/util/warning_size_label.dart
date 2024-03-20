import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              aedappfm.Iconsax.info_circle,
              color: Colors.yellow,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              AppLocalizations.of(context)!.informations,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.betaVersionMaxFiles,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
