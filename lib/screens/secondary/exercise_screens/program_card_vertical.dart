// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/create_goal.dart';
import 'package:mhs_application/components/exercise_components/today_target.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/secondary/notifications.dart';
import 'package:mhs_application/services/database.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/primary/Program.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_collection.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_details.dart';
import 'package:mhs_application/services/exercise_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/shared/custom_alert_dialog.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ProgramCardVertical extends StatefulWidget {
  const ProgramCardVertical({super.key});

  @override
  State<ProgramCardVertical> createState() => _ProgramCardVerticalState();
}

class _ProgramCardVerticalState extends State<ProgramCardVertical> {
  TextEditingController targetExercise = TextEditingController();
  TextEditingController targetMinutes = TextEditingController();
  TextEditingController targetBurned = TextEditingController();

  List<String> goals = [];
  List<String> programsName = [
    'Muscle Building',
    'Weight Lose',
    'Running',
    'Brisk Walking'
  ];
  List<String> programsText = [
    'Build Your Muscle',
    'Lose Your Weight',
    'Run For Life',
    'Walk Your Life'
  ];
  List<String> image = [
    'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg',
    'assets/images/Pushups_0.jpg',
    'assets/images/Running.jpg',
    'assets/images/Brisk_Walking.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Programs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
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
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's target",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const CustomAlertDialog(
                            title: 'Information',
                            message:
                                "The progress bar may increase even if you don't set anything to indicate that you have done something today.",
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: greenColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _createTodayGoal();
                    },
                    child: Icon(
                      Icons.add,
                      color: greenColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const TodayTarget(),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
          child: Text(
            'Explore our programs for a healthier you!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: programsName.length,
          itemBuilder: (context, index) {
            String program = programsName[index];
            String programText = programsText[index];
            String programImage = image[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Card(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 190,
                        child: Image.asset(
                          programImage,
                          width: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          program,
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          print('User select $program');
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  _programSelection(context, program),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
                            color: whiteColor.withOpacity(0.9),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PROGRAM',
                                    style: TextStyle(
                                      color: greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    programText,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: greenColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _programSelection(BuildContext context, String programNames) {
    BottomNavigationBarShared.navigationKey.currentState
        ?.setBottomNavBarVisible(false);

    switch (programNames) {
      case 'Muscle Building':
      case 'Weight Lose':
        return ExerciseCollection(
          programName: programNames,
          exerciseList: [],
        );
      case 'Running':
      case 'Brisk Walking':
        return FutureBuilder<Exercise>(
          future: ExerciseDatabaseService().fetchRunningWalking(programNames),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              Exercise selectedExercise = snapshot.data ?? Exercise();
              return ExerciseDetails(
                programName: programNames,
                selectedExercise: selectedExercise,
              );
            }
          },
        );
      default:
        return const Program();
    }
  }

  void addGoal(String goal) {
    setState(() {
      goals.add(goal);
    });
  }

  void _createTodayGoal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 550,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: CreateGoal(addGoal: addGoal),
        );
      },
    );
  }
}
