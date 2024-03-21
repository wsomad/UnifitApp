import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:mhs_application/models/exercise.dart';
import 'dart:convert';

class ExerciseDatabaseService { 

  Future<List<Exercise>> readExerciseData() async {

    final DatabaseReference exerciseReference = FirebaseDatabase.instance.ref('exercises/');
    List<Exercise> exerciseList = [];
    StreamController<List<Exercise>> controller = StreamController();

    exerciseReference.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        Map<Object?, Object?> rawData = child.value as Map<Object?, Object?>;

        // Convert to a JSON string and then parse it as Map<String, dynamic>
        Map<String, dynamic> data = json.decode(json.encode(rawData));

        exerciseList.add(Exercise.fromJson(data));
        controller.add(exerciseList);
      }
    }, 
    onError: (error) {
      controller.addError(error);
    });
    return controller.stream.first;
  }

  Future<Exercise> fetchRunningWalking(String programName) async {
    List<Exercise> exercise =
        await ExerciseDatabaseService().readExerciseData();

    Exercise selectedExercise =
        exercise.firstWhere((exercise) => exercise.name == programName);

    return selectedExercise;
  }
}