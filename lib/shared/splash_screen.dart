import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mhs_application/shared/constant.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int count = 3;
  late Timer timer;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    startCountDown();
  }

  void startCountDown() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (count > 0) {
          audioPlayer.play(AssetSource('audio/countdown.mp3'));
          count--;
        } else {
          timer.cancel();
          widget.onComplete();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SpinKitPulse(
              color: greenColor.withOpacity(0.5),
              size: 500,
            ),
            Center(
              child: Text(
                count == 0 ? 'Go' : (count).toString(),
                style: TextStyle(
                  fontSize: 100,
                  color: greenColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
