import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhs_application/components/profile_components/profile_bottom_sheet.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/secondary/activitiy_screens/badges_collection.dart';
import 'package:mhs_application/screens/secondary/activitiy_screens/leaderboard.dart';
import 'package:mhs_application/screens/secondary/activitiy_screens/weekly_progression.dart';
import 'package:mhs_application/services/databases/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/components/custom_dialogs/custom_bmi_dialog.dart';
import 'package:provider/provider.dart';

class ActivityCollection extends StatefulWidget {
  const ActivityCollection({super.key});

  @override
  State<ActivityCollection> createState() => _ActivityCollectionState();
}

class _ActivityCollectionState extends State<ActivityCollection> {
  var day = DateTime.now().weekday;
  var currentWeek = ExerciseExecution().getCurrentWeek();
  int previousWeek = ExerciseExecution().getPreviousWeek();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    void showBottomSheet() {
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: 280,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: const ProfileBottomSheet(),
          );
        },
      );
    }

    return ListView(
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                child: Image(
                  image: AssetImage(
                    'assets/images/unifit_logo.png',
                  ),
                  height: 25,
                  width: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showBottomSheet();
                          },
                          child: Icon(
                            Icons.menu,
                            color: greenColor,
                            size: 26,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(color: greenColor, width: 2),
                          )),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Weekly Progression',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) {
                              return const WeeklyProgression();
                            },
                          ));
                        },
                        style: inputTinyButtonDecoration,
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<Student>(
                      stream: StudentDatabaseService().readCurrentStudentData(
                          '${studentUser?.uid}',
                          'execute/week $currentWeek/progress'),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        var bmi = data?.bmi ?? 0;
                        var countTotalExercise = data?.countTotalExercise ?? 0;
                        var countTotalTime = data?.countTotalTime ?? 0;
                        var countTotalCalories = data?.countTotalCalories ?? 0;
                        var bmiCategory = Student().determineBMI(bmi);

                        return Column(children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.accessibility_new_rounded,
                                            color: greenColor,
                                            size: 22,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'BMI',
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
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    bmi.toStringAsFixed(2),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 26,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Text(
                                                    'kg/m2',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black26,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            bmiCategory.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black26,
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return const CustomInputDialog(
                                                    title: 'Requirement',
                                                    message:
                                                        'Kindly update your weight',
                                                  );
                                                },
                                              );
                                            },
                                            child: CircleAvatar(
                                              maxRadius: 12,
                                              backgroundColor: greenColor,
                                              child: Icon(
                                                Icons.arrow_circle_up_rounded,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            countTotalExercise.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Exercise',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Completed',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            countTotalTime.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Minutes',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Spent',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          )
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            'Calories',
                                            style: TextStyle(
                                              color: blackColor,
                                              fontSize: 15,
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
                                            countTotalCalories.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Calories',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Burned',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]);
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(color: greenColor, width: 2),
                    )),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Weekly Leaderboard',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                    child: Text(
                      'View',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<List<Student>>(
              stream: StudentDatabaseService().readAllStudentsRank('students'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final students = snapshot.data ?? [];
                final studentUser = Provider.of<Student?>(context)?.uid;
                students.sort((a, b) => (b.countTotalCalories ?? 0)
                    .compareTo(a.countTotalCalories ?? 0));

                final currentUserIndex = students
                    .indexWhere((student) => student.uid == studentUser);

                // Display user position if found in the sorted list
                if (currentUserIndex != -1) {
                  final userPosition = currentUserIndex +
                      1; // Adding 1 since positions start from 1, not 0
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: grey100Color,
                      ),
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current position',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey),
                          ),
                          Text(
                            '$userPosition',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text(
                    'Execute activities to be in the leaderboard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ); // If user position is not found, display nothing
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(color: greenColor, width: 2),
                    )),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Weekly Badges Collection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) {
                          return const BadgesCollection();
                        },
                      ));
                    },
                    style: inputTinyButtonDecoration,
                    child: Text(
                      'View',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: grey100Color,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Burn Calories &',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Collect All Badges',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Positioned(
                          left: 100, 
                          child: Image(
                            image: AssetImage('assets/images/500.png'),
                            height: 70,
                            width: 80,
                          ),
                        ),
                        Positioned(
                          left: 55,
                          child: Image(
                            image: AssetImage('assets/images/1000.png'),
                            height: 70,
                            width: 90,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 60),
                          child: Image(
                            image: AssetImage('assets/images/3000.png'),
                            height: 100,
                            width: 120,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ],
    );
  }
}
