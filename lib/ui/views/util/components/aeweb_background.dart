import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:flutter/material.dart';
import 'package:lit_starfield/view.dart';

class AEWebBackground extends StatelessWidget {
  const AEWebBackground({
    this.withAnimation = false,
    super.key,
  });

  final bool withAnimation;

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
                ArchethicThemeBase.purple500.withOpacity(0.8),
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
        if (withAnimation)
          Opacity(
            opacity: 0.8,
            child: LitStarfieldContainer(
              velocity: 0.2,
              number: 200,
              starColor: ArchethicThemeBase.neutral0,
              scale: 3,
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
        if (withAnimation)
          Opacity(
            opacity: 0.3,
            child: LitStarfieldContainer(
              velocity: 0.5,
              number: 100,
              scale: 10,
              starColor: ArchethicThemeBase.blue500,
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
      ],
    );
  }
}
