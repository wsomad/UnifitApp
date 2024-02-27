import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/rest_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/models/time.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class RunningWalkingExecution extends StatefulWidget {
  final Exercise selectedExercise;
  final String programName;
  final TimeDetails timeDetails;
  const RunningWalkingExecution({
    super.key,
    required this.selectedExercise,
    required this.programName,
    required this.timeDetails,
  });

  @override
  State<RunningWalkingExecution> createState() =>
      _RunningWalkingExecutionState();
}

class _RunningWalkingExecutionState extends State<RunningWalkingExecution> {
  int second = 0;
  int minute = 0;
  int hour = 0;
  bool isTimerRunning = false;
  bool isBottomSheetOpen = false;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    Exercise exercise = widget.selectedExercise;
    var exerciseName = exercise.name!;
    var exerciseLevel = exercise.level!;
    var exerciseEquipment = exercise.equipment!;
    int totalSeconds = (widget.timeDetails.hours! * 3600) +
        (widget.timeDetails.minutes! * 60) +
        widget.timeDetails.seconds!;

    if (exerciseLevel.isNotEmpty) {
      exerciseLevel = exerciseLevel[0].toUpperCase() +
          exerciseLevel.substring(1).toLowerCase();
    }

    if (exerciseEquipment.isNotEmpty) {
      exerciseEquipment = exerciseEquipment[0].toUpperCase() +
          exerciseEquipment.substring(1).toLowerCase();
    }

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: greenColor,
                    ),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Let's Go!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text('      '),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                Text(
                  exerciseName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      exerciseLevel,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: greenColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      exerciseEquipment,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 550,
                  //MediaQuery.of(context).size.height,
                  //color: Colors.pink,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularPercentIndicator(
                        radius: 160,
                        lineWidth: 15,
                        percent: second / totalSeconds,
                        progressColor: greenColor,
                        backgroundColor: greyColor,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Container(
                          //color: Colors.pink,
                          height: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(
                                  Duration(seconds: second),
                                ),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (!isTimerRunning) {
                                    startTimer();
                                  } else {
                                    showBottomSheet();
                                  }
                                },
                                style: inputSmallButtonDecoration.copyWith(
                                    backgroundColor:
                                        MaterialStatePropertyAll(greenColor),
                                    side: MaterialStatePropertyAll(
                                      BorderSide(color: greenColor, width: 2.0),
                                    )),
                                child: Text(
                                  isTimerRunning ? 'Pause' : 'Start',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '${(second / totalSeconds * 100).toStringAsFixed(0)}% on progress!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: inputLargeButtonDecoration,
                          child: Text(
                            'Done',
                            style: TextStyle(
                                color: whiteColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    int totalSeconds = (widget.timeDetails.hours! * 3600) +
        (widget.timeDetails.minutes! * 60) +
        widget.timeDetails.seconds!;
    if (second < totalSeconds) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          second++;
        });
        if (second >= totalSeconds) {
          stopTimer();
          setState(() {
            isTimerRunning = false;
          });
        }
        setState(() {
          isTimerRunning = true;
        });
      });
    }
  }

  void stopTimer() {
    timer.cancel();
  }

  void showBottomSheet() {
    setState(() {
      isBottomSheetOpen = true;
    });

    timer.cancel();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 300,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: const RestBottomSheet()),
        );
      },
    ).whenComplete(() {
      setState(() {
        isBottomSheetOpen = false;
      });
      startTimer();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
