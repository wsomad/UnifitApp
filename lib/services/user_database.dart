// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';

class StudentDatabaseService {
  final String? uid;
  StudentDatabaseService({this.uid});

  final DatabaseReference studentReference = FirebaseDatabase.instance.ref();
  ExerciseExecution execution = ExerciseExecution();

  Stream<Student> readCurrentStudentData(String dataPath) {
    final DatabaseReference studentReference =
        FirebaseDatabase.instance.ref(dataPath);
    
    return studentReference.onValue.map((event) {
      try {
        if (event.snapshot.value != null) {
          Map<Object?, Object?> rawData = event.snapshot.value as Map<Object?, Object?>;

          Map<String, dynamic> data = json.decode(json.encode(rawData));

          return Student.fromJson(data);
        } else {
          return Student();
        }
      } catch (e) {
        // Return a default value or handle the error accordingly
        print('Error fetching current student data: $e');
        return Student();
      }
    });
  }

  // 
  Future<void> storeStudentExerciseData(String userId, String exerciseId, int currentWeek, int currentDay, Map<String, dynamic> exerciseData) async {
    await studentReference.child('students/$userId/progress/week $currentWeek/day $currentDay, $exerciseId').update(exerciseData);
  }

  Future<void> shiftWeekNumber(String userId) async {
    // Get total weeks
    int weekIndex = execution.getCurrentWeek();
    int weekTotal = execution.getTotalWeeks();
    int firstWeek = (weekIndex - weekTotal) + 1;
    print('First week: $firstWeek');
    
    // Remove 
    if((weekIndex - 1) > 0) {
      for (var i = 3; i < 4; i++) {
        await studentReference.child('students/$userId/progress/week $i').remove();
      }
    }
    for (var i = 1; i <= 3; i++) {
      // Source path
      final event = await studentReference.child('students/$userId/progress/week $i').once();
      if (event.snapshot.value != null) {
        // Destination path
        await studentReference.child('students/$userId/progress/week ${i+1}').set(event.snapshot.value);
        await studentReference.child('students/$userId/progress/week $i').remove();
      }
    }
    
/*
    if(event.snapshot.value != null) {
      for (int i = currentWeek - 1; i >= 1; i--) {
        await studentReference.child('students/$userId/progress/week $currentWeek').update({
        'week ': {i+1},
      });
        //await studentReference.child(path)
        //await StudentDatabaseService().moveData('students/$userId/progress/week $i', 'students/$userId/progress/week ${i + 2}');
      }
    }
    await studentReference.child('students/$userId/progress/week $currentWeek').update({
        'week ': 1,
      });*/
  }

  Future<void> storeShiftProcess(String userId, int currentWeek, String exerciseId, Map<String, dynamic> exerciseData) async {
    await storeStudentExerciseData(userId, exerciseId, currentWeek, exerciseData);
    await shiftWeekNumber(userId);
  }

  Future<void> moveData(String userId, int index, int destinationIndex) async {
    /*
    final DatabaseReference studentReference =
        FirebaseDatabase.instance.ref();

    final event = await studentReference.child(sourcePath).once();
    if(event.snapshot.value != null) {
      await studentReference.child(destinationPath).set(event.snapshot.value);
      await studentReference.child(sourcePath).remove();
    }*/
    
    // Source path
    final event = await studentReference.child('students/$userId/progress/week $index').once();
    if (event.snapshot.value != null) {
      // Destination path
      await studentReference.child('students/$userId/progress/week $destinationIndex').set(event.snapshot.value);
      await studentReference.child('students/$userId/progress/week $index').remove();
    }
  }

  Future<void> removeData(String userId, int index) async {
    /*final DatabaseReference studentReference =
        FirebaseDatabase.instance.ref();
    await studentReference.child(path).remove();*/
    // Get total weeks
    int weekIndex = execution.getCurrentWeek();
    int weekTotal = execution.getTotalWeeks();
    int firstWeek = (weekIndex - weekTotal) + 1;
    print('First week: $firstWeek');
    
    // Remove 
    await studentReference.child('students/$userId/progress/week $index').remove();
  }

  Future<int> getDataLength(String databasePath) async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    var event = await databaseRef.child(databasePath).once();
    
    // Check if data exists
    if (event.snapshot.value != null) {
      return (event.snapshot.value as Map).length;
    }
    
    // Return 0 if data is empty or in a different format
    return 0;
  }
}