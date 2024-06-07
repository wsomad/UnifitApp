import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/rest_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/models/time.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_output.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/shared/custom_validation_dialog.dart';
import 'package:mhs_application/shared/splash_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:slider_button/slider_button.dart';

class RunningWalkingExecution extends StatefulWidget {
  final Exercise selectedExercise;
  final String programName;
  final TimeDetails timeDetails;
  final String image;

  const RunningWalkingExecution({
    super.key,
    required this.selectedExercise,
    required this.programName,
    required this.timeDetails,
    required this.image,
  });

  @override
  State<RunningWalkingExecution> createState() =>
      _RunningWalkingExecutionState();
}

class _RunningWalkingExecutionState extends State<RunningWalkingExecution> {
  int seconds = 0;
  int second = 0;
  int minute = 0;
  int hour = 0;
  bool isTimerRunning = false;
  bool isBottomSheetOpen = false;
  bool showSplash = false;
  Timer timer = Timer(Duration.zero, () {});
  var day = DateTime.now().weekday;
  var week = ExerciseExecution().getCurrentWeek();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    Stream<List<dynamic>> combinedStream = CombineLatestStream.combine3(
      StudentDatabaseService().readCurrentStudentData(
          '${studentUser?.uid}', 'execute/week $week/progress'),
      StudentDatabaseService().readCurrentStudentData(
          '${studentUser?.uid}', 'execute/week $week/day $day/Goals'),
      StudentDatabaseService()
          .readCurrentStudentData('${studentUser?.uid}', 'personal'),
      (bmiData, goalsData, userData) => [bmiData, goalsData, userData],
    );

    return StreamBuilder<List<dynamic>>(
        stream: combinedStream,
        builder: (context, snapshot) {
          // From progress node
          final progressData = snapshot.data?[0];
          var overallTotalExercise = progressData?.countTotalExercise ?? 0;
          var overallTotalTime = progressData?.countTotalTime ?? 0.0;
          var overallTotalCalories = progressData?.countTotalCalories ?? 0;

          // From goals node
          final goalsData = snapshot.data?[1];
          var countTotalExercise = goalsData?.countTotalExercise ?? 0;
          var countTotalTime = goalsData?.countTotalTime ?? 0.0;
          var countTotalCalories = goalsData?.countTotalCalories ?? 0;

          // From personal node
          final userData = snapshot.data?[2];
          var weight = userData?.weight ?? 0;

          Exercise exercise = widget.selectedExercise;
          var exerciseId = exercise.id!;
          var exerciseName = exercise.name!;
          var exerciseLevel = exercise.level!;
          var exerciseMet = exercise.met!;
          var exerciseEquipment = exercise.equipment!;
          var exerciseImage = exercise.images![0];
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

          String formattedDuration = _formatDuration(Duration(seconds: second));
          double totalTimes = _calculateTotalMinutes(formattedDuration);
          String totalTimeFormatted = totalTimes.toStringAsFixed(2);
          double totalTime = double.parse(totalTimeFormatted);

          return Scaffold(
            body: showSplash
                ? SplashScreen(
                    onComplete: () {
                      setState(() {
                        // When the splash screen completes, hide it
                        showSplash = false;
                      });
                      // Start the timer when the splash screen completes
                      startTimer();
                    },
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                            onTap: () async {
                              // Show confirmation dialog
                              bool? confirm = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomValidationDialog(
                                    title: 'Confirmation',
                                    message: 'Are you sure you want to leave this screen?',
                                    onYesPressed: () {
                                      Navigator.of(context).pop(true); // Return true to indicate confirmation
                                    },
                                  );
                                },
                              );
                              if (confirm == null) {
                                return; // Exit without further action
                              }
                              if (confirm == true) {
                                Navigator.of(context).pop(); // If confirmed, pop the Navigator stack
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: greenColor,
                              ),
                            ),
                          ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text(
                                  exerciseName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Icon(
                                Icons.list_rounded,
                                color: greenColor,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          children: [
                            Container(
                              height: 400,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                setState(() {
                                                  showSplash = true;
                                                });
                                              } else {
                                                showBottomSheet();
                                              }
                                            },
                                            style: inputSmallButtonDecoration
                                                .copyWith(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            greenColor),
                                                    side:
                                                        MaterialStatePropertyAll(
                                                      BorderSide(
                                                          color: greenColor,
                                                          width: 2.0),
                                                    )),
                                            child: Text(
                                              isTimerRunning
                                                  ? 'Pause'
                                                  : 'Start',
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
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.show_chart_rounded,
                                          size: 24,
                                          color: greenColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'Progression',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 140,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: grey100Color,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: CircularPercentIndicator(
                                        radius: 60,
                                        lineWidth: 10,
                                        progressColor: greenColor,
                                        backgroundColor: greyColor,
                                        percent: second / totalSeconds,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        center: Text(
                                          '${(second / totalSeconds * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.favorite_rounded,
                                          size: 20,
                                          color: greenColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'Calories Burned',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 140,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: grey100Color,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: CircularPercentIndicator(
                                        radius: 60,
                                        lineWidth: 10,
                                        progressColor: greenColor,
                                        backgroundColor: greyColor,
                                        percent: second / totalSeconds,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        center: Center(
                                          child: Text(
                                            (((exerciseMet * 3.5 * weight) /
                                                        200) *
                                                    totalTimes)
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            SizedBox(
                              height: 60,
                              width: 300,
                              child: SliderButton(
                                action: () async {
                                  double total = totalTime;
                                  double totalCaloriesBurned =
                                      ((exerciseMet * 3.5 * weight) / 200) *
                                          totalTime;
                                  int convertCalories =
                                      totalCaloriesBurned.toInt();
                                  int maxWeek = 52;
                                  countTotalExercise++;
                                  countTotalTime += total;
                                  countTotalCalories += convertCalories;
                                  overallTotalExercise++;
                                  overallTotalTime += total;
                                  overallTotalCalories += convertCalories;
                              
                                  stopTimer();
                              
                                  ExerciseExecution execution = ExerciseExecution(
                                    exerciseName: exerciseName,
                                    totalTime: totalTime,
                                  );
                              
                                  await StudentDatabaseService()
                                      .storeStudentExerciseData(
                                    '${studentUser?.uid}',
                                    exerciseId,
                                    week,
                                    day,
                                    execution.toJsonDate(),
                                  );
                                  await StudentDatabaseService().updateTarget(
                                    '${studentUser?.uid}',
                                    week,
                                    day,
                                    countTotalExercise,
                                    countTotalTime,
                                    countTotalCalories,
                                  );
                              
                                  DatabaseReference ref =
                                      FirebaseDatabase.instance.ref(
                                          'students/${studentUser?.uid}/execute/week $week/progress');
                                  await ref.update({
                                    'countTotalExercise': overallTotalExercise,
                                    'countTotalTime': overallTotalTime,
                                    'countTotalCalories': overallTotalCalories,
                                  });
                              
                                  /* Original Code
                                  await _databaseService.updateData(
                                      'students/${studentUser?.uid}/execute/week $week/day $day/$exerciseId',
                                      execution.toJsonDate());*/
                                        /*
                                  DatabaseReference ref = FirebaseDatabase.instance.ref(
                                      'students/${studentUser?.uid}/execute/week $week/day $day/Goals');
                                  await ref.update({
                                    'countTotalExercise': countTotalExercise,
                                    'countTotalTime': countTotalTime,
                                  });*/
                              
                                  if (week == 52) {
                                    if (maxWeek == week) {
                                      for (var i = 40; i <= 52; i++) {
                                        await StudentDatabaseService()
                                            .removeData('${studentUser?.uid}', i);
                                      }
                                      for (int i = 39; i >= 1; i--) {
                                        await StudentDatabaseService().moveData(
                                            '${studentUser?.uid}', i, i + 4);
                                      }
                                    } else {
                                      print("You haven't reached week 52");
                                    }
                                  }
                              
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExerciseOutput(
                                        finalReps: [],
                                        selectedExercise: widget.selectedExercise,
                                        programName: widget.programName,
                                        exerciseName: exerciseName,
                                        caloriesBurned: convertCalories,
                                        timeSpent: totalTime,
                                        rep: 0,
                                        set: 0,
                                        image: exerciseImage,
                                      ),
                                    ),
                                  );
                                  return null;
                                },
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 50),
                                  child: Text(
                                    'Slide to complete',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width * 0.8,
                                buttonColor: greenColor,
                                backgroundColor: grey100Color,
                                baseColor: greenColor,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  double _calculateTotalMinutes(String formattedDuration) {
    List<String> parts = formattedDuration.split(':');
    double hours = double.parse(parts[0]);
    double minutes = double.parse(parts[1]);
    double seconds = double.parse(parts[2]);
    return (hours * 60) + minutes + (seconds / 60);
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
    isTimerRunning = false;
  }

  void showBottomSheet() {
    setState(() {
      isBottomSheetOpen = true;
    });

    timer.cancel();

    showModalBottomSheet(
      context: context,
      isDismissible: false,
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
