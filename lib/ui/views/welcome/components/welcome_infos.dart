import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gradient_borders/gradient_borders.dart';

class WelcomeInfos extends StatelessWidget {
  const WelcomeInfos({
    required this.welcomeArgTitle,
    required this.welcomeArgDesc,
    this.animationDuration = 200,
    super.key,
  });

  final String welcomeArgTitle;
  final String welcomeArgDesc;
  final int animationDuration;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.9;
    var height = 230.0;
    if (aedappfm.Responsive.isDesktop(context) == true) {
      width = MediaQuery.of(context).size.width / 6;
      height = MediaQuery.of(context).size.height * 0.5;
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.background.withOpacity(1),
            Theme.of(context).colorScheme.background.withOpacity(0.3),
          ],
          stops: const [0, 1],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0xFFCC00FF),
              Color(0x003C89B9),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: aedappfm.ArchethicScrollbar(
        child: SizedBox(
          child: Column(
            children: [
              Text(
                welcomeArgTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                welcomeArgDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(
          duration: Duration(milliseconds: animationDuration),
        )
        .scale(
          duration: Duration(milliseconds: animationDuration),
        );
  }
}
