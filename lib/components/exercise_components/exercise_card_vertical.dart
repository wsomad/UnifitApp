import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_details.dart';
import 'package:mhs_application/services/exercise_database.dart';
import 'package:mhs_application/shared/constant.dart';

class ExerciseCardVertical extends StatefulWidget {
  final String programName;
  final List<Exercise> exerciseList;
  final List<Exercise> filteredExerciseList;

  const ExerciseCardVertical({
    super.key,
    required this.programName,
    required this.exerciseList,
    required this.filteredExerciseList,
  });

  @override
  State<ExerciseCardVertical> createState() => _ExerciseCardVerticalState();
}

class _ExerciseCardVerticalState extends State<ExerciseCardVertical> {
  final ExerciseDatabaseService exerciseDatabaseService =
      ExerciseDatabaseService();

  List<Exercise> _displayRandomExercises(
      List<Exercise> exerciseList, int count) {
    List<Exercise> randomExercises = List.from(exerciseList)..shuffle();
    return randomExercises.take(count).toList();
  }

  List<Exercise> _displayFilteredExercises(
      List<Exercise> filteredExerciseList, int count) {
    List<Exercise> randomFilteredExercises = List.from(filteredExerciseList)
      ..shuffle();
    return randomFilteredExercises.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: exerciseDatabaseService.readExerciseData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No exercises found.');
        } else {
          List<Exercise> exercises = snapshot.data!;
          List<Exercise> currentList = widget.filteredExerciseList.isNotEmpty
              ? _displayFilteredExercises(widget.filteredExerciseList,
                  min(10, widget.filteredExerciseList.length))
              : _displayRandomExercises(exercises, 10);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentList.length,
            itemBuilder: (context, index) {
              Exercise exercise = currentList[index];
              var exerciseName = exercise.name!;
              var exerciseImage =
                  'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
              //exercise.imagesPath![0];
              var exerciseLevel = exercise.level!;
              var exerciseEquipment = exercise.equipment!;

              Color? levelColor;
              if (exerciseLevel.isNotEmpty) {
                if (exerciseLevel == "beginner") {
                  levelColor = beginnerColor;
                } else if (exerciseLevel == "intermediate") {
                  levelColor = intermediateColor;
                } else {
                  levelColor = expertColor;
                }
              }

              if (exerciseLevel.isNotEmpty) {
                exerciseLevel = exerciseLevel[0].toUpperCase() +
                    exerciseLevel.substring(1).toLowerCase();
              }

              if (exerciseEquipment.isNotEmpty) {
                exerciseEquipment = exerciseEquipment[0].toUpperCase() +
                    exerciseEquipment.substring(1).toLowerCase();
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  elevation: 5,
                  child: Stack(
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: levelColor,
                                ),
                                child: Text(
                                  exerciseLevel,
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 85,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exerciseName,
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                //const SizedBox(height: 5,),
                                Container(
                                  //color: Colors.pink,
                                  height: 30,
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        exerciseEquipment,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                ExerciseDetails(
                                                programName: widget.programName,
                                                selectedExercise: exercise,
                                              ),
                                            ),
                                          );
                                        },
                                        style: inputTinyButtonDecoration,
                                        child: Text(
                                          'View',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
