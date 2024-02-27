import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/build_lose_list.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/rest_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/shared/constant.dart';

class BuildLoseExecution extends StatefulWidget {
  final Exercise selectedExercise;
  final int set;
  final int rep;

  const BuildLoseExecution(
      {super.key,
      required this.selectedExercise,
      required this.set,
      required this.rep});

  @override
  State<BuildLoseExecution> createState() => _BuildLoseExecutionState();
}

class _BuildLoseExecutionState extends State<BuildLoseExecution> {
  late Timer timer;
  int seconds = 0;
  bool isTimerRunning = false;
  bool isTimerPaused = false;
  bool isBottomSheetOpen = false;
  Color setButtonColor = greenColor;
  Color setOutlineColor = greenColor;

  @override
  Widget build(BuildContext context) {
    Exercise exercise = widget.selectedExercise;
    var exerciseName = exercise.name!;
    var exerciseImage = 'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
    var exerciseLevel = exercise.level!;
    var exerciseEquipment = exercise.equipment!;

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
                  onTap: () {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 180,
                    child: Image.asset(
                      exerciseImage,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 70,
                      height: 30,
                      color: whiteColor,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _formatDuration(Duration(seconds: seconds)),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!isTimerRunning) {
                          startTimer();
                        } 
                        else {
                          showBottomSheet();
                        } 
                      },
                      style: inputTinyButtonDecoration.copyWith(
                        backgroundColor:
                            MaterialStateProperty.all(setButtonColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  setOutlineColor, // Set the outline color here
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        isTimerRunning ? 'Rest' : 'Start',
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: BuildLoseList(
                    rep: widget.rep,
                    set: widget.set,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: inputLargeButtonDecoration,
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: whiteColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t) {
      if (!isTimerPaused) {
      setState(() {
        seconds++;
      });
    }
    });
    setState(() {
      isTimerRunning = true;
    });
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
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child:const RestBottomSheet()
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        isBottomSheetOpen = false;
      });
      startTimer();
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
