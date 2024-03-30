// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_database/firebase_database.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';

class StudentDatabaseService {
  // Create a nullable uid variable
  final String? uid;

  // Create a constructor with uid parameter
  StudentDatabaseService({this.uid});

  // Create an instance of database named studentReference 
  final DatabaseReference studentReference = FirebaseDatabase.instance.ref();

  // Create an instance named execution
  ExerciseExecution execution = ExerciseExecution();
  
  // Create a Student stream to read only current student data with userID and sourcePath parameter
  Stream<Student> readCurrentStudentData(String userId, String sourcePath) {
    // Assign a variable to hold the reference for student data
    var ref = studentReference.child('students/$userId/$sourcePath');
    // By referring to the assign variable, any processes (event) happened is mapped 
    return ref.onValue.map((event) {
      try {
        // Check the availability 
        // It stored student data in snapshot object after a process
        if (event.snapshot.value != null) {
          // Initially, we 
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

  Stream<List<Student>> readAllStudents(String sourcePath) {
    var ref = studentReference.child(sourcePath);

    return ref.onValue.map((event) {
      List<Student> students = [];
      try {
        if (event.snapshot.value != null) {
          Map<String, dynamic> data = event.snapshot.value as Map<String, dynamic>;
          data.forEach((key, value) {
            students.add(Student.fromJson(value));
          });
        }
      } 
      catch (e) {
        print('Error: $e');
      }
      print('All Student: $students');
      return students;
    });
  }

Future<List<Student>> readfAllStudents(String sourcePath) async {
    var ref = studentReference.child(sourcePath);

    try {
      var snapshot = await ref.once();
      final event = snapshot.snapshot.value; // Await for the snapshot to be available
      
      List<Student> students = [];
      
      if (event != null) {
        Map<String, dynamic> data = event as Map<String, dynamic>;
        
        data.forEach((key, value) {
          students.add(Student.fromJson(value));
        });
      }
      
      print('All Students: $students');
      
      return students;
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list in case of error
    }
  }

  // 
  Future<void> storeStudentExerciseData(String userId, String exerciseId, int currentWeek, int currentDay, Map<String, dynamic> exerciseData) async {
    try {
      await studentReference.child('students/$userId/execute/week $currentWeek/day $currentDay/$exerciseId').update(exerciseData);
    } catch (e) {
      print('Error storing student exercise data: $e');
      rethrow;
    }
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
        await studentReference.child('students/$userId/execute/week $i').remove();
      }
    }
    for (var i = 1; i <= 3; i++) {
      // Source path
      final event = await studentReference.child('students/$userId/execute/week $i').once();
      if (event.snapshot.value != null) {
        // Destination path
        await studentReference.child('students/$userId/execute/week ${i+1}').set(event.snapshot.value);
        await studentReference.child('students/$userId/execute/week $i').remove();
      }
    }
  }

  Future<void> moveData(String userId, int index, int destinationIndex) async {    
    // Source path
    final event = await studentReference.child('students/$userId/execute/week $index').once();
    if (event.snapshot.value != null) {
      // Destination path
      await studentReference.child('students/$userId/execute/week $destinationIndex').set(event.snapshot.value);
      await studentReference.child('students/$userId/execute/week $index').remove();
    }
  }

  Future<void> removeData(String userId, int index) async {
    // Get total weeks
    int weekIndex = execution.getCurrentWeek();
    int weekTotal = execution.getTotalWeeks();
    int firstWeek = (weekIndex - weekTotal) + 1;
    print('First week: $firstWeek');
    
    // Remove 
    await studentReference.child('students/$userId/execute/week $index').remove();
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