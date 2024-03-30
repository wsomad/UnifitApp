// ignore_for_file: avoid_print
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/build_lose_list.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/rest_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_output.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class BuildLoseExecution extends StatefulWidget {
  final Exercise selectedExercise;
  final int set;
  final int rep;

  const BuildLoseExecution({
    super.key,
    required this.selectedExercise,
    required this.set,
    required this.rep,
  });

  @override
  State<BuildLoseExecution> createState() => _BuildLoseExecutionState();
}

class _BuildLoseExecutionState extends State<BuildLoseExecution> {
  Timer timer = Timer(Duration.zero, () {});
  int exerciseIndex = 1;
  int seconds = 0;
  bool isTimerRunning = false;
  bool isTimerPaused = false;
  bool isBottomSheetOpen = false;
  Color setButtonColor = greenColor;
  Color setOutlineColor = greenColor;
  var day = DateTime.now().weekday;
  var currentWeek = ExerciseExecution().getCurrentWeek();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    Stream<List<dynamic>> combinedStream = CombineLatestStream.combine3(
      StudentDatabaseService().readCurrentStudentData(
          '${studentUser?.uid}', 'execute/week $currentWeek/progress'),
      StudentDatabaseService().readCurrentStudentData(
          '${studentUser?.uid}', 'execute/week $currentWeek/day $day/Goals'),
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
          var overallTotalTime = progressData?.countTotalTime ?? 0;
          var overallTotalCalories = progressData?.countTotalCalories ?? 0;
          print('overall calories $overallTotalCalories');

          // From goals node
          final goalsData = snapshot.data?[1];
          var countTotalExercise = goalsData?.countTotalExercise ?? 0;
          var countTotalTime = goalsData?.countTotalTime ?? 0;
          var countTotalCalories = goalsData?.countTotalCalories ?? 0;
          print('count calories $countTotalCalories');

          // From personal node
          final userData = snapshot.data?[2];
          var weight = userData?.weight ?? 0;
          print('weight $weight');

          Exercise exercise = widget.selectedExercise;
          var exerciseId = exercise.id!;
          var exerciseName = exercise.name!;
          var exerciseImage =
              'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
          var exerciseLevel = exercise.level!;
          var exerciseMet = exercise.met!;
          print('met $exerciseMet');
          var exerciseEquipment = exercise.equipment!;
          print('equip $exerciseEquipment');

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              } else {
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
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
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
                        onPressed: () async {
                          stopTimer();

                          String formattedDuration =
                              _formatDuration(Duration(seconds: seconds));
                          double totalTimes =
                              _calculateTotalMinutes(formattedDuration);
                          String totalTimeFormatted =
                              totalTimes.toStringAsFixed(2);
                          double totalTime = double.parse(totalTimeFormatted);
                          int total = totalTime.toInt();
                          int maxWeek = 13;
                          double totalCaloriesBurned =
                              ((exerciseMet * 3.5 * weight) / 200) * totalTime;
                          int convertCalories = totalCaloriesBurned.toInt();

                          print('total $totalCaloriesBurned');
                          countTotalExercise++;
                          countTotalTime += total;
                          countTotalCalories += convertCalories;
                          overallTotalExercise++;
                          overallTotalTime += total;
                          overallTotalCalories += countTotalCalories;

                          ExerciseExecution execution = ExerciseExecution(
                            exerciseName: exerciseName,
                            totalTime: totalTime,
                          );

                          // Original code
                          //await _databaseService.updateData('students/${studentUser.uid}/progress/week $week/day $day/$exerciseId', execution.toJsonDate());

                          // Store current exercise details
                          // Improvised code
                          await StudentDatabaseService()
                              .storeStudentExerciseData(
                            '${studentUser?.uid}',
                            exerciseId,
                            currentWeek,
                            day,
                            execution.toJsonDate(),
                          );

                          DatabaseReference ref = FirebaseDatabase.instance.ref(
                              'students/${studentUser?.uid}/execute/week $currentWeek/day $day/Goals');
                          await ref.update({
                            'countTotalExercise': countTotalExercise,
                            'countTotalTime': countTotalTime,
                            'countTotalCalories': countTotalCalories,
                          });
                          print('Total Exercise: $countTotalExercise');

                          DatabaseReference ref2 = FirebaseDatabase.instance.ref(
                              'students/${studentUser?.uid}/execute/week $currentWeek/progress');
                          await ref2.update({
                            'countTotalExercise': overallTotalExercise,
                            'countTotalTime': overallTotalTime,
                            'countTotalCalories': overallTotalCalories,
                          });

                          if (currentWeek == 4) {
                            if (maxWeek == currentWeek) {
                              for (var i = 10; i <= 13; i++) {
                                await StudentDatabaseService()
                                    .removeData('${studentUser?.uid}', i);
                              }
                              for (int i = 9; i >= 1; i--) {
                                await StudentDatabaseService()
                                    .moveData('${studentUser?.uid}', i, i + 4);
                              }
                            } else {
                              print("You haven't reached week 13");
                            }
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseOutput(
                                exerciseName: exerciseName,
                                caloriesBurned: convertCalories,
                                timeSpent: totalTime,
                                rep: widget.rep,
                                set: widget.set,
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  double _calculateTotalMinutes(String formattedDuration) {
    List<String> parts = formattedDuration.split(':');
    double hours = double.parse(parts[0]);
    double minutes = double.parse(parts[1]);
    double seconds = double.parse(parts[2]);
    return (hours * 60) + minutes + (seconds / 60);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
