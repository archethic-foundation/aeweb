/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:flutter/material.dart';

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
        Image.asset(
          'assets/images/logo_crystal.png',
          height: 50,
        ),
        const SizedBox(
          width: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'aeHosting',
            style: TextStyle(
              fontSize: 30,
              color: ArchethicThemeBase.blue200,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 20),
          child: Text(
            'Beta',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
