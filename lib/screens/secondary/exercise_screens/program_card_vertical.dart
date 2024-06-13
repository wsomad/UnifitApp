// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/create_goal.dart';
import 'package:mhs_application/components/exercise_components/today_target.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/primary/bottom_navigation_bar.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/primary/Program.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_collection.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_details.dart';
import 'package:mhs_application/services/databases/exercise_database.dart';
import 'package:mhs_application/services/databases/student_database.dart';
import 'package:mhs_application/components/custom_dialogs/bmi_weekly_dialog.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/components/custom_dialogs/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

class ProgramCardVertical extends StatefulWidget {
  const ProgramCardVertical({super.key});

  @override
  State<ProgramCardVertical> createState() => _ProgramCardVerticalState();
}

class _ProgramCardVerticalState extends State<ProgramCardVertical> {
  var day = DateTime.now().weekday;
  var currentWeek = ExerciseExecution().getCurrentWeek();
  int previousWeek = ExerciseExecution().getPreviousWeek();
  late final Stream<Student?> studentStream;
  TextEditingController targetExercise = TextEditingController();
  TextEditingController targetMinutes = TextEditingController();
  TextEditingController targetBurned = TextEditingController();
  List<String> goals = [];
  List<String> programsName = [
    'Brisk Walking',
    'Running',
    'Muscle Building',
    'Weight Loss',
  ];
  List<String> programsText = [
    'Walk Your Life',
    'Run For Life',
    'Build Your Muscle',
    'Lose Your Weight',
  ];
  List<String> image = [
    'assets/images/Brisk_Walking.png',
    'assets/images/Running.jpg',
    'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg',
    'assets/images/Pushups_0.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final student = Provider.of<Student?>(context, listen: false);
        if (student != null && student.uid != null && student.uid is String) {
          BMIWeeklyDialog.initializeDialogState(
            context, currentWeek, previousWeek, day, student.uid as String);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<Student?>(context, listen: false);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
              StreamBuilder<Student?>(
                stream: StudentDatabaseService()
                  .readCurrentStudentData('${student?.uid}', 'personal')
                  .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data');
                  } else {
                    final student = snapshot.data;
                    var username = student?.username ?? 'null';

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            'Hello, $username',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                      "Daily target",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                      size: 24,
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 0, 10),
          child: Row(
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
                      'Explore our programs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(programImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
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
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                            color: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Program',
                                    style: TextStyle(
                                      color: greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    programText,
                                    style: TextStyle(
                                      color: whiteColor,
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
                                  color: whiteColor,
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
        return ExerciseCollection(
          programName: programNames,
          exerciseList: const [],
          sets: 5,
          reps: 9,
          type: 'Muscle Building',
        );
      case 'Weight Loss':
        return ExerciseCollection(
          programName: programNames,
          exerciseList: const [],
          sets: 3,
          reps: 13,
          type: 'Weight Loss',
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
                sets: 0,
                reps: 0,
                type: 'null',
                image: 'null',
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
