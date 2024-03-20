/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/version.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
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

    var width = MediaQuery.of(context).size.width * 0.9;
    if (aedappfm.Responsive.isDesktop(context) == true) {
      width = MediaQuery.of(context).size.width / 6;
    }

    return SizedBox(
      width: width,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/AELogo-Public Blockchain-White.svg',
            semanticsLabel: 'AE Logo',
            height: 22,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            asyncVersionString.asData?.value ?? '',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
