import 'package:flutter/material.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/build_lose_bottom_sheet.dart';
import 'package:mhs_application/components/exercise_components/bottom_sheets/running_walking_bottom_sheet.dart';
import 'package:mhs_application/models/exercise.dart';

class ExerciseSetup extends StatefulWidget {
  final String programName;
  final Exercise selectedExercise;

  const ExerciseSetup({
    super.key,
    required this.programName,
    required this.selectedExercise,
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
        selectedExercise: widget.selectedExercise,
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
      );
    }
  }
}
