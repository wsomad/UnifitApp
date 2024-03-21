// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/components/exercise_components/exercise_setup.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class ExerciseDetails extends StatefulWidget {
  final String programName;
  final Exercise selectedExercise;

  const ExerciseDetails({
    super.key,
    required this.programName,
    required this.selectedExercise,
  });

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  Color setButtonColor = greenColor;
  Color setOutlineColor = greenColor;

  void showBottomSheet() {
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
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: ExerciseSetup(
              programName: widget.programName,
              selectedExercise: widget.selectedExercise,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    print('Dispose called for ${widget.programName}');
    BottomNavigationBarShared.navigationKey.currentState
        ?.setBottomNavBarVisible(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<Student>(context);

    return StreamBuilder<Student>(
      stream: StudentDatabaseService(uid: student.uid)
          .readCurrentStudentData('students/${student.uid}/personal'),
      builder: ((context, snapshot) {
        // Student Data
        final data = snapshot.data;

        // Student Weight
        var studentWeight = data?.weight;
        num weight = studentWeight ?? 0.0;

        // Exercise Data
        Exercise exercise = widget.selectedExercise;
        var exerciseName = exercise.name!;
        var exerciseImage =
            'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
        var exerciseLevel = exercise.level!;
        var exerciseEquipment = exercise.equipment!;
        var exercisePrimaryMuscle = exercise.primaryMuscles![0];
        var exerciseSecondaryMuscle = exercise.secondaryMuscles![0];
        var exerciseInstructions = exercise.instructions!;
        var exerciseMet = exercise.met!;

        if (exerciseLevel.isNotEmpty) {
          exerciseLevel = exerciseLevel[0].toUpperCase() +
              exerciseLevel.substring(1).toLowerCase();
        }

        if (exerciseEquipment.isNotEmpty) {
          exerciseEquipment = exerciseEquipment[0].toUpperCase() +
              exerciseEquipment.substring(1).toLowerCase();
        }

        if (exercisePrimaryMuscle.isNotEmpty) {
          exercisePrimaryMuscle = exercisePrimaryMuscle[0].toUpperCase() +
              exercisePrimaryMuscle.substring(1).toLowerCase();
        }

        if (exerciseSecondaryMuscle.isNotEmpty) {
          exerciseSecondaryMuscle = exerciseSecondaryMuscle[0].toUpperCase() +
              exerciseSecondaryMuscle.substring(1).toLowerCase();
        }

        double totalCaloriesBurned = ((exerciseMet * 3.5 * weight) / 200) * 30;
        int convert = totalCaloriesBurned.toInt();
        String caloriesBurned = convert.toString();

        return Scaffold(
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: EdgeInsets.only(bottom: 10, left: 50),
                        child: Text(
                          'Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          showBottomSheet();
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
                          'Set',
                          style: TextStyle(
                              color: whiteColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 180,
                        child: Image.asset(
                          exerciseImage,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      exerciseName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.electric_bolt_outlined,
                                color: greenColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                exerciseLevel,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.fitness_center_rounded,
                                color: greenColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                exerciseEquipment,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Primary Muscle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          exercisePrimaryMuscle,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Secondary Muscle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          exerciseSecondaryMuscle,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Calories Burned',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '(In 30 min)',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Text(
                          caloriesBurned,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: exerciseInstructions.length,
                          itemBuilder: (context, index) {
                            var instructions = exerciseInstructions[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('[${index + 1}] $instructions',
                                    textAlign: TextAlign.justify),
                                const SizedBox(height: 8),
                              ],
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
