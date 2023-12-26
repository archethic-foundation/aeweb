/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderWelcomeScreen extends StatelessWidget {
  const HeaderWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/AELogo.svg',
          semanticsLabel: 'AE Logo',
          height: 40,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          'aeHosting',
          style: TextStyle(
            fontSize: 45,
            color: ArchethicThemeBase.blue200,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Text(
            'Beta',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
