/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.labelBtn,
    this.icon,
    this.onPressed,
    this.height = 30,
    this.disabled = false,
  });
  final IconData? icon;
  final String labelBtn;
  final Function? onPressed;
  final bool disabled;
  final double height;

  @override
  AppButtonState createState() => AppButtonState();
}

class AppButtonState extends State<AppButton> {
  bool _over = false;

  @override
  void initState() {
    super.initState();
  }

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
      child: widget.disabled
          ? OutlinedButton(
              style: ButtonStyle(
                side: MaterialStateProperty.all(BorderSide.none),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: null,
              child: _buttonContent(),
            )
          : widget.onPressed == null
              ? OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: null,
                  child: _buttonContent(),
                ).animate(target: _over ? 0 : 1).fade(end: 0.8)
              : OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    widget.onPressed!();
                  },
                  child: _buttonContent(),
                ).animate(target: _over ? 0 : 1).fade(end: 0.8),
    );
  }

  Widget _buttonContent() {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF00A4DB),
            Color(0xFFCC00FF),
          ],
          transform: GradientRotation(pi / 9),
        ),
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 7,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null)
            Icon(
              widget.icon,
              color: widget.disabled
                  ? Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .color!
                      .withOpacity(0.3)
                  : Theme.of(context).textTheme.labelMedium!.color,
              size: 12,
            ),
          if (widget.icon != null) const SizedBox(width: 5),
          Text(
            widget.labelBtn,
            style: TextStyle(
              color: widget.disabled
                  ? Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .color!
                      .withOpacity(0.3)
                  : Theme.of(context).textTheme.labelMedium!.color,
              fontFamily: 'Equinox',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
