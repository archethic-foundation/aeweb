import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  const Countdown({this.duration = const Duration(minutes: 1), super.key});

  final Duration duration;
  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  double progressValue = 1;
  Timer? timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsedSeconds++;
        progressValue = (widget.duration.inSeconds - elapsedSeconds) /
            widget.duration.inSeconds;
        if (progressValue <= 0.0) {
          timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(5, 5),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: CircularProgressIndicator(
          strokeWidth: 7,
          value: progressValue,
        ),
      ),
    );
  }
}
