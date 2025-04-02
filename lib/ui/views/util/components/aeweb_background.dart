import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:flutter/material.dart';

class AEWebBackground extends StatelessWidget {
  const AEWebBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                ArchethicThemeBase.purple500.withValues(alpha: 0.8),
                BlendMode.modulate,
              ),
              image: const AssetImage(
                'assets/images/background-welcome.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Opacity(
          opacity: 0.8,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background-welcome-gradient.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
