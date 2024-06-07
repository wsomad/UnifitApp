import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/build_lose_bottom_sheet.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/running_walking_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';

class ExerciseSetup extends StatefulWidget {
  final String programName;
  final Exercise selectedExercise;
  final int sets;
  final int reps;
  final String type;
  final String image;

  const ExerciseSetup({
    super.key,
    required this.programName,
    required this.selectedExercise,
    required this.sets,
    required this.reps,
    required this.type,
    required this.image,
  });

  @override
  State<ExerciseSetup> createState() => _ExerciseSetupState();
}

class _ExerciseSetupState extends State<ExerciseSetup> {
  @override
  Widget build(BuildContext context) {
    if (widget.programName == 'Muscle Building' ||
        widget.programName == 'Weight Lose') {
      return BuildLoseBottomSheet(
        programName: widget.programName,
        selectedExercise: widget.selectedExercise,
        sets: widget.sets,
        reps: widget.reps,
        type: widget.type,
        image: widget.image,
      );
    } else if (widget.programName == 'Running' ||
        widget.programName == 'Brisk Walking') {
      return RunningWalkingBottomSheet(
        programName: widget.programName,
        selectedExercise: widget.selectedExercise,
      );
    } else {
      return ExerciseSetup(
        programName: widget.programName,
        selectedExercise: widget.selectedExercise,
        sets: widget.sets,
        reps: widget.reps,
        type: 'null',
        image: 'null',
      );
    }
  }
}
