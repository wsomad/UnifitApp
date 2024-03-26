import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/secondary/activitiy_screens/leaderboard.dart';
import 'package:mhs_application/screens/secondary/activitiy_screens/progression.dart';
import 'package:mhs_application/screens/secondary/notifications.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ActivityCollection extends StatefulWidget {
  const ActivityCollection({super.key});

  @override
  State<ActivityCollection> createState() => _ActivityCollectionState();
}

class _ActivityCollectionState extends State<ActivityCollection> {

  var day = DateTime.now().weekday;
  var currentWeek = ExerciseExecution().getCurrentWeek();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    return ListView(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => const Notifications(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: greenColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Weekly Progression',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                    StreamBuilder<Student>(
                      stream: StudentDatabaseService().readCurrentStudentData('${studentUser?.uid}', 'execute/week $currentWeek/progress'),
                      builder: (context, snapshot) {

                        final data = snapshot.data;
                        var bmi = data?.bmi ?? 0;
                        var countTotalExercise = data?.countTotalExercise ?? 0;
                        var countTotalTime = data?.countTotalTime ?? 0;
                        var countTotalCalories = data?.countTotalCalories ?? 0;

                        var bmiCategory = Student().determineBMI(bmi);

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 140,
                                width: 160,
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
                                            Icons.accessibility_new_rounded,
                                            color: greenColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'BMI',
                                            style: TextStyle(
                                              color: blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    bmi.toStringAsFixed(2),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  const Text(
                                                    'kg/m2',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black26
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            bmiCategory.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black26
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context, rootNavigator: true).push(
                                                MaterialPageRoute(builder: (context) {
                                                  return const Progression(typeofProgression: 'bmi',);
                                                },)
                                              );
                                            },
                                            child: CircleAvatar(
                                              maxRadius: 13,
                                              backgroundColor: greenColor,
                                              child: Icon(
                                                Icons.arrow_outward_rounded,
                                                size: 16,
                                                color: grey100Color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
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
                                          const SizedBox(
                                            width: 10,
                                          ),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            countTotalExercise.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Exercise',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Completed',
                                                style: TextStyle(
                                                    color: Colors.black26,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context, rootNavigator: true).push(
                                              MaterialPageRoute(builder: (context) {
                                                return const Progression(typeofProgression: 'exercise',);
                                              },)
                                            );
                                          },
                                          child: CircleAvatar(
                                            maxRadius: 13,
                                            backgroundColor: greenColor,
                                            child: Icon(
                                              Icons.arrow_outward_rounded,
                                              size: 16,
                                              color: grey100Color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
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
                                          const SizedBox(
                                            width: 10,
                                          ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            countTotalTime.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Minutes',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Spent',
                                                style: TextStyle(
                                                    color: Colors.black26,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context, rootNavigator: true).push(
                                              MaterialPageRoute(builder: (context) {
                                                return const Progression(typeofProgression: 'timeSpent',);
                                              },)
                                            );
                                          },
                                          child: CircleAvatar(
                                            maxRadius: 13,
                                            backgroundColor: greenColor,
                                            child: Icon(
                                              Icons.arrow_outward_rounded,
                                              size: 16,
                                              color: grey100Color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Container(
                                  height: 140,
                                  width: 160,
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
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              countTotalCalories.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            const Text(
                                              'Burned',
                                              style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                            onTap: () {
                                            Navigator.of(context, rootNavigator: true).push(
                                              MaterialPageRoute(builder: (context) {
                                                return const Progression(typeofProgression: 'calories',);
                                              },)
                                            );
                                          },
                                            child: CircleAvatar(
                                              maxRadius: 13,
                                              backgroundColor: greenColor,
                                              child: Icon(
                                                Icons.arrow_outward_rounded,
                                                size: 16,
                                                color: grey100Color,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Badges Collection',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: inputTinyButtonDecoration,
                  child: Text('View',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: whiteColor)),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) {
                        return const Leaderboard();
                      },
                    ));
                  },
                  style: inputTinyButtonDecoration,
                  child: Text('View',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: whiteColor)),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
