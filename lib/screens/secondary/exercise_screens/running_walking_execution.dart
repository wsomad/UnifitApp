import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/rest_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/models/time.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_output.dart';
import 'package:mhs_application/services/database.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

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
  final DatabaseService _databaseService = DatabaseService();
  int seconds = 0;
  int second = 0;
  int minute = 0;
  int hour = 0;
  bool isTimerRunning = false;
  bool isBottomSheetOpen = false;
  Timer timer = Timer(Duration.zero, () { });
  var day = DateTime.now().weekday;
  var week = ExerciseExecution().getCurrentWeek();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);
    var studentWeight = studentUser?.weight;
    num weight = studentWeight ?? 0.0;
    
    Exercise exercise = widget.selectedExercise;
    var exerciseId = exercise.id!;
    var exerciseName = exercise.name!;
    var exerciseLevel = exercise.level!;
    var exerciseMet = exercise.met!;
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

    double totalCaloriesBurned = ((exerciseMet * 3.5 * weight) / 200) * 30;
    int convert = totalCaloriesBurned.toInt();

    return StreamBuilder<Student>(
      stream: StudentDatabaseService(uid: studentUser!.uid)
                        .readCurrentStudentData(
                            'students/${studentUser.uid}/execute/week $week/day $day/Goals'),
      builder: (context, snapshot) {

        final data = snapshot.data;

        var countTotalExercise = data?.countTotalExercise ?? 0;
        var countTotalTime = data?.countTotalTime ?? 0;
        
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
                              onPressed: () async {
                                stopTimer();
        
                                String formattedDuration = _formatDuration(Duration(seconds: second));
                                double totalTimes = _calculateTotalMinutes(formattedDuration);
                                String totalTimeFormatted = totalTimes.toStringAsFixed(2);
                                double totalTime = double.parse(totalTimeFormatted);
                                int total = totalTime.toInt();
                                countTotalExercise++;
                                countTotalTime+=total;
                                
                                ExerciseExecution execution = ExerciseExecution(
                                  exerciseName: exerciseName,
                                  totalTime: totalTime,
                                );
                                execution.updateCurrentWeek();
        
                                await _databaseService.updateData('students/${studentUser!.uid}/execute/week $week/day $day/$exerciseId', execution.toJsonDate());
                                
                                DatabaseReference ref = FirebaseDatabase.instance.ref('students/${studentUser.uid}/execute/week $week/day $day/Goals');
                                await ref.update({
                                  'countTotalExercise': countTotalExercise,
                                  'countTotalTime': countTotalTime,
                                });
                                print('Current total exercise: $countTotalExercise');
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    ExerciseOutput(
                                      exerciseName: exerciseName,
                                      caloriesBurned: convert,
                                      timeSpent: totalTime,
                                      rep: 0,
                                      set: 0,
                                    ),
                                  ),
                                );
                              },
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
    );
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
