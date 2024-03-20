/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        if (aedappfm.Responsive.isMobile(context) == false)
          SvgPicture.asset(
            'assets/images/AELogo.svg',
            height: 34,
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SvgPicture.asset(
              'assets/images/AELogo.svg',
              height: 24,
            ),
          ),
        if (aedappfm.Responsive.isMobile(context) == false)
          const SizedBox(
            width: 8,
          ),
        if (aedappfm.Responsive.isMobile(context) == false)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SelectableText(
              'aeHosting',
              style: TextStyle(
                fontSize: 33,
                color: aedappfm.ArchethicThemeBase.neutral0,
              ),
            ),
          ),
        if (aedappfm.Responsive.isMobile(context) == false)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 26),
            child: SelectableText(
              'Beta',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}
