import 'package:aeweb/application/version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeInfoVersion extends ConsumerWidget {
  const WelcomeInfoVersion({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVersionString = ref.watch(
      versionStringProvider(
        AppLocalizations.of(context)!,
      ),
    );

    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/AELogo-Public Blockchain-White.svg',
          semanticsLabel: 'AE Logo',
          height: 30,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          asyncVersionString.asData?.value ?? '',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
