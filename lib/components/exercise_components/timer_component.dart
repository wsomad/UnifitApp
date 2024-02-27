import 'dart:async';

import 'package:flutter/material.dart';

class TimerComponent extends StatefulWidget {
  const TimerComponent({super.key});

  @override
  State<TimerComponent> createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent> {
  late Timer timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSecond = const Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) { 
      setState(() {
        seconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(Duration(seconds: seconds));

    return Text(
      formattedTime,

    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}