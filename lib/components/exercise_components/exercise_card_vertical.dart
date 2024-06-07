import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/exercise_details.dart';
import 'package:mhs_application/shared/constant.dart';

class ExerciseCardVertical extends StatelessWidget {
  final String programName;
  final List<Exercise> exerciseList;
  final List<Exercise> filteredExerciseList;
  final int sets;
  final int reps;
  final String type;

  const ExerciseCardVertical({
    super.key,
    required this.programName,
    required this.exerciseList,
    required this.filteredExerciseList,
    required this.sets,
    required this.reps,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    List<Exercise> currentList = filteredExerciseList.isNotEmpty
        ? filteredExerciseList
        : exerciseList;

    currentList = currentList.where((exercise) =>
        exercise.name != 'Running' && exercise.name != 'Brisk Walking').toList();
        
    if (currentList.isEmpty) {
      return const Center(
        child: Text(
          'No exercises found.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        Exercise exercise = currentList[index];
        var exerciseName = exercise.name!;
        var exerciseImage = (exercise.images != null && exercise.images!.isNotEmpty)
            ? exercise.images![0] // Get the first image URL
            : 'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg'; // Default image

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

        exerciseLevel = exerciseLevel[0].toUpperCase() +
            exerciseLevel.substring(1).toLowerCase();

        exerciseEquipment = exerciseEquipment[0].toUpperCase() +
            exerciseEquipment.substring(1).toLowerCase();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Card(
            elevation: 5,
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
                        image: exerciseImage.startsWith('http')
                            ? CachedNetworkImageProvider(exerciseImage)
                            : AssetImage(exerciseImage) as ImageProvider,
                        fit: BoxFit.cover,
                      )
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 85),
                      Text(
                        exerciseName,
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              exerciseEquipment,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                fontSize: 14,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExerciseDetails(
                                      programName: programName,
                                      selectedExercise: exercise,
                                      sets: sets,
                                      reps: reps,
                                      type: type,
                                      image: exerciseImage,
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
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
