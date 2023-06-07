import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconAnimated extends ConsumerStatefulWidget {
  const IconAnimated({
    required this.icon,
    required this.color,
    this.iconSize = 20,
    super.key,
  });

  final IconData icon;
  final double iconSize;
  final Color color;

  @override
  ConsumerState<IconAnimated> createState() => IconAnimatedState();
}

class IconAnimatedState extends ConsumerState<IconAnimated> {
  bool _over = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _over = true;
        });
      },
      onExit: (_) {
        setState(() {
          _over = false;
        });
      },
      child: Icon(
        widget.icon,
        color: widget.color,
      ).animate(target: _over ? 1 : 0).scaleXY(end: 1.3),
    );
  }
}
