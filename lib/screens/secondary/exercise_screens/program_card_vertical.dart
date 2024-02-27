// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/primary/Program.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_collection.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_details.dart';
import 'package:mhs_application/services/exercise_database.dart';
import 'package:mhs_application/shared/constant.dart';

class ProgramCardVertical extends StatefulWidget {
  const ProgramCardVertical({super.key});

  @override
  State<ProgramCardVertical> createState() => _ProgramCardVerticalState();
}

class _ProgramCardVerticalState extends State<ProgramCardVertical> {
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

  Future<Exercise> fetchRunningWalking(String programName) async {
    List<Exercise> exercise =
        await ExerciseDatabaseService().readExerciseData();

    Exercise selectedExercise =
        exercise.firstWhere((exercise) => exercise.name == programName);

    return selectedExercise;
  }
/*
  void changeImage() {
    setState(() {
      // Change the image when the button is pressed
      image = "assets/New_Image.jpg";
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
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
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: greenColor,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: const Text(
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
          future: fetchRunningWalking(programNames),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            else {
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
}
