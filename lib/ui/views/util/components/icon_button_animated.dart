import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconButtonAnimated extends ConsumerStatefulWidget {
  const IconButtonAnimated({
    required this.icon,
    required this.onPressed,
    required this.color,
    this.iconSize = 20,
    this.tooltip = '',
    super.key,
  });

  final Icon icon;
  final double iconSize;
  final String tooltip;
  final Function onPressed;
  final Color color;

  @override
  ConsumerState<IconButtonAnimated> createState() => IconButtonAnimatedState();
}

class IconButtonAnimatedState extends ConsumerState<IconButtonAnimated> {
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
      child: IconButton(
        onPressed: () {
          setState(() {
            _over = true;
          });
          widget.onPressed();
        },
        icon: widget.icon.animate(target: _over ? 1 : 0).scaleXY(end: 1.3),
        tooltip: widget.tooltip,
        iconSize: widget.iconSize,
        color: widget.color,
      ),
    );
  }
}
