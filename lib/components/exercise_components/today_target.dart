import 'package:flutter/material.dart';
import 'package:mhs_application/models/badges.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/badge_database.dart';
import 'package:mhs_application/services/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TodayTarget extends StatefulWidget {
  const TodayTarget({super.key});

  @override
  State<TodayTarget> createState() => _TodayTargetState();
}

class _TodayTargetState extends State<TodayTarget> {
  var day = DateTime.now().weekday;
  var currentWeek = ExerciseExecution().getCurrentWeek();

  List<Badges> awardedBadges = [];
  bool _badgesAwarded = false;
  late String? _student;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _student = Provider.of<Student?>(context, listen: false)?.uid;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForNewBadges();
    });
  }

  void checkForNewBadges() async {
    if (!_badgesAwarded) {
      String? userID = Provider.of<Student?>(context, listen: false)?.uid;
      final Stream<Student> totalCaloriesStream = getTotalCalories(userID!);

      await for (var student in totalCaloriesStream) {
        if (!mounted) return;
        int? totalCalories = student.countTotalCalories ?? 0;
        List<Badges> badges =
            await BadgeDatabaseService().readBadgeDetails('badges/calories');
        awardedBadges = await BadgeDatabaseService()
            .todayCaloriesBurned(totalCalories, badges, userID);

        if (awardedBadges.isNotEmpty) {
          if (!mounted) return;
          setState(() {
            _badgesAwarded = true;
          });
          showAwardedBadgesDialog(context);
        }
      }
    }
  }

  Stream<Student> getTotalCalories(String userID) {
    return StudentDatabaseService().readCurrentStudentData(
        userID, 'execute/week $currentWeek/day $day/Goals');
  }

  void showAwardedBadgesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'New Badge Unlocked',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: awardedBadges.map((badge) {
              return Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10)
                  )
                ),
                height: 200,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      badge.badgeImagePath!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: inputLargeButtonDecoration,
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _student;
    _badgesAwarded = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);
    var day = DateTime.now().weekday;
    var week = ExerciseExecution().getCurrentWeek();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: StreamBuilder<Student?>(
        stream: StudentDatabaseService(uid: studentUser?.uid)
            .readCurrentStudentData(
                '${studentUser?.uid}', 'execute/week $week/day $day/Goals'),
        builder: (context, snapshot) {
          final targetData = snapshot.data;

          // Target exercise progression
          var targetExerciseValue = targetData?.targetNoOfExercise ?? '0';
          num targetExercise = int.parse(targetExerciseValue);
          var completedExercise = targetData?.countTotalExercise ?? 0;
          var progressExercisePercent = 0.0;
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
          var progressTimePercent = 0.0;
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
          var progressCaloriesBurned = 0.0;
          if (completedCalories == 0) {
            progressCaloriesBurned = 0.0;
          } else {
            progressCaloriesBurned =
                (completedCalories / targetCalories).clamp(0.0, 1.0);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 130,
                    width: 170,
                    decoration: BoxDecoration(
                      color: grey100Color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.fitness_center_rounded,
                                color: greenColor,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Exercise',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircularPercentIndicator(
                                backgroundColor: greyColor,
                                lineWidth: 12,
                                radius: 30,
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
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '/${targetExerciseValue.toString()}',
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
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 130,
                    width: 170,
                    decoration: BoxDecoration(
                      color: grey100Color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
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
                                size: 22,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Time Spent',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircularPercentIndicator(
                                backgroundColor: greyColor,
                                lineWidth: 12,
                                radius: 30,
                                progressColor: greenColor,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: progressTimePercent,
                              ),
                              Column(
                                children: [
                                  Text(
                                    completedTime.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: grey100Color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
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
                            size: 22,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Calories Burned',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircularPercentIndicator(
                            backgroundColor: greyColor,
                            lineWidth: 12,
                            radius: 30,
                            progressColor: greenColor,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent: progressCaloriesBurned,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                completedCalories.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'of ${targetCaloriesValue.toString()} calories',
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
            ],
          );
        },
      ),
    );
  }
}