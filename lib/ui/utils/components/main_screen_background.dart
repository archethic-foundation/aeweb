import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:flutter/material.dart';

class MainScreenBackground extends StatelessWidget {
  const MainScreenBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                ArchethicThemeBase.plum500.withOpacity(0.8),
                BlendMode.modulate,
              ),
              image: const AssetImage(
                'assets/images/background-menu.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/background-mainscreen.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
