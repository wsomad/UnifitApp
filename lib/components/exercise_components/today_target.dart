import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TodayTarget extends StatefulWidget {
  const TodayTarget({super.key});

  @override
  State<TodayTarget> createState() => _TodayTargetState();
}

class _TodayTargetState extends State<TodayTarget> {
  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);
    var day = DateTime.now().weekday;
    var week = ExerciseExecution().getCurrentWeek();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: StreamBuilder<Student?>(
        stream: StudentDatabaseService(uid: studentUser!.uid)
            .readCurrentStudentData(
                '${studentUser.uid}', '/execute/week $week/day $day/Goals'),
        builder: (context, snapshot) {
          final targetData = snapshot.data;

          // Target exercise progression
          var targetExerciseValue = targetData?.targetNoOfExercise ?? '0';
          num targetExercise = int.parse(targetExerciseValue);
          var completedExercise = targetData?.countTotalExercise ?? 0;
          var progressExercisePercent;
          if (completedExercise == 0) {
            progressExercisePercent = 0.0;
          } else {
            progressExercisePercent =
                (completedExercise / targetExercise).clamp(0.0, 1.0);
          }

          // Target time progression
          var targetTimeValue = targetData?.targetTimeSpent ?? '0';
          num targetTime = int.parse(targetTimeValue);
          var completedTime = targetData?.countTotalTime ??
              0; // Replace with your actual completed exercise count
          var progressTimePercent;
          if (completedTime == 0) {
            progressTimePercent = 0.0;
          } else {
            progressTimePercent = (completedTime / targetTime).clamp(0.0, 1.0);
          }

          // Target time progression
          var targetCaloriesValue = targetData?.targetCaloriesBurned ?? '0';
          num targetCalories = int.parse(targetCaloriesValue);
          var completedCalories = targetData?.countTotalCalories ??
              0; // Replace with your actual completed exercise count
          var progressCaloriesBurned;
          if (completedCalories == 0) {
            progressCaloriesBurned = 0.0;
          } else {
            progressCaloriesBurned = (completedCalories / targetCalories).clamp(0.0, 1.0);
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 140,
                  width: 160,
                  decoration: BoxDecoration(
                    color: grey100Color,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.fitness_center_rounded,
                              color: greenColor,
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              'Exercise',
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              backgroundColor: greyColor,
                              lineWidth: 12,
                              radius: 35,
                              progressColor: greenColor,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: progressExercisePercent,
                            ),
                            Column(
                              children: [
                                Text(
                                  completedExercise.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '/ ${targetExerciseValue.toString()}',
                                  style: const TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  height: 140,
                  width: 160,
                  decoration: BoxDecoration(
                    color: grey100Color,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: greenColor,
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              'Time Spent',
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              backgroundColor: greyColor,
                              lineWidth: 12,
                              radius: 35,
                              progressColor: greenColor,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: progressTimePercent,
                            ),
                            Column(
                              children: [
                                Text(
                                  completedTime.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '/${targetTimeValue.toString()} min',
                                  style: const TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    height: 140,
                    width: 160,
                    decoration: BoxDecoration(
                      color: grey100Color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                color: greenColor,
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                'Calories',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircularPercentIndicator(
                                backgroundColor: greyColor,
                                lineWidth: 12,
                                radius: 35,
                                progressColor: greenColor,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: progressCaloriesBurned,
                              ),
                              Column(
                                children: [
                                  Text(
                                    completedCalories.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '/ ${targetCaloriesValue.toString()}',
                                    style: const TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*
Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target No. of Exercise',
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        LinearPercentIndicator(
                          backgroundColor: greyColor,
                          lineHeight: 8,
                          progressColor: greenColor,
                          barRadius: const Radius.circular(10),
                          percent: progressExercisePercent,
                          trailing: Text(
                            targetExerciseValue.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target Time Spent (min)',
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        LinearPercentIndicator(
                          backgroundColor: greyColor,
                          lineHeight: 8,
                          progressColor: greenColor,
                          barRadius: const Radius.circular(10),
                          percent: progressTimePercent,
                          trailing: Text(
                            targetTimeValue.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target Calories Burned',
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        LinearPercentIndicator(
                          backgroundColor: greyColor,
                          lineHeight: 8,
                          progressColor: greenColor,
                          barRadius: const Radius.circular(10),
                          percent: 0,
                          trailing: const Text(
                            '0',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),*/
