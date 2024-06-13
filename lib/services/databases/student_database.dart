// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mhs_application/models/badges.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/post.dart';
import 'package:mhs_application/models/student.dart';
import 'package:rxdart/rxdart.dart';

class StudentDatabaseService {
  // Create a nullable uid variable
  final String? uid;

  // Create a constructor with uid parameter
  StudentDatabaseService({this.uid});

  // Create an instance of database named studentReference 
  final DatabaseReference studentReference = FirebaseDatabase.instance.ref();

  // Create an instance named execution
  ExerciseExecution execution = ExerciseExecution();

  var currentWeek = ExerciseExecution().getCurrentWeek();
  
  // Read current student data with two parameters (ID, source path)
  Stream<Student> readCurrentStudentData(String userId, String? sourcePath) {
    // Assign a variable to hold the reference for student data
    var ref = studentReference.child('students/$userId/$sourcePath');
    // By referring to the assign variable, any processes (event) happened is mapped 
    return ref.onValue.switchMap((event) async* {
      try {
        // Check the availability 
        // It stored student data in snapshot object after a process
        if (event.snapshot.value != null) {
          // Initially, we 
          Map<Object?, Object?> rawData = event.snapshot.value as Map<Object?, Object?>;
          Map<String, dynamic> data = json.decode(json.encode(rawData));
          yield Student.fromJson(data);
        } else {
          yield Student();
        }
      } catch (e) {
        // Return a default value or handle the error accordingly
        print('Error fetching current student data: $e');
        yield Student();
      }
    });
  }

  // Read all student post data
  Stream<List<Post>> readAllStudentsPost(String sourcePath) async* {
    var ref = studentReference.child(sourcePath);

    await for (var event in ref.onValue) {
      List<Post> students = [];
      try {
        for (final child in event.snapshot.children) {
          if (child.value != null) {
            Map<Object?, Object?> rawData = child.value as Map<Object?, Object?>;
            Map<String, dynamic> data = json.decode(json.encode(rawData));
            students.add(Post.fromJson(data));
          }
        }
      } catch (e) {
        print('Error: $e');
      }
      yield students;
    }
  }

  Stream<Student> readStudentBadges(String userId, String sourcePath) async* {
    var ref = studentReference.child('students/$userId/$sourcePath');

    try {
      List<Badges> badges = [];
      await for (var event in ref.onValue) {
        for (final child in event.snapshot.children) {
          if (child.value != null) {
            Map<Object?, Object?> userData = child.value as Map<Object?, Object?>;
            Map<String, dynamic> badge = json.decode(json.encode(userData));
            String badgeID = badge['badgeID'];
            String badgeName = badge['badgeName'];
            String badgeImagePath = badge['badgeImagePath'];
            String badgeType = badge['badgeType'];

            // Create a Badges object for each badge
            Badges badge2 = Badges(
              badgeID: badgeID,
              badgeName: badgeName,
              badgeImagePath: badgeImagePath,
              badgeType: badgeType,
            );
            // Add the badge to the list
            badges.add(badge2);
          }
        }
        if (badges.isNotEmpty) {
        // If badges are collected, yield a single Student object containing all badges
        yield Student(badge: badges);
      }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<List<MapEntry<String, dynamic>>> displayBMI(String userId) async* {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('students/$userId/execute');
    final snapshot = await ref.once();

    final weekBmis = <MapEntry<String, dynamic>>[];

    if (snapshot.snapshot.value != null) {
      Map<Object?, Object?> rawData = snapshot.snapshot.value as Map<Object?, Object?>;
      Map<String, dynamic> execute = json.decode(json.encode(rawData));

      int currentWeek = ExerciseExecution().getCurrentWeek();

      for (int i = 1; i <= currentWeek; i++) {
        String weekKey = 'week $i';
        if (execute.containsKey(weekKey) && execute[weekKey]['progress'] != null && execute[weekKey]['progress']['bmi'] != null) {
          double bmi = execute[weekKey]['progress']['bmi'];
          weekBmis.add(MapEntry(weekKey, bmi));
        } else {
          weekBmis.add(MapEntry(weekKey, 'No data'));
        }
      }
    } else {
      for (int i = 1; i <= ExerciseExecution().getCurrentWeek(); i++) {
        weekBmis.add(MapEntry('week $i', 'No data'));
      }
    }
    yield weekBmis;
  }

  Stream<List<Student>> readAllStudentsRank(String sourcePath) async* {
    var ref = studentReference.child(sourcePath);

    await for (var event in ref.onValue) {
      List<Student> students = [];
      try {
        for (final child in event.snapshot.children) {
          if (child.value != null) {
            String userId = child.key as String;
            Map<Object?, Object?> userData = child.value as Map<Object?, Object?>;

            if (userData.containsKey('personal')) {
              Map<Object?, Object?> personalData = userData['personal'] as Map<Object?, Object?>;
              Map<String, dynamic> decodePersonalData = json.decode(json.encode(personalData));
              Map<Object?, Object?> executeData = userData['execute'] as Map<Object?, Object?>;
              Map<String, dynamic> decodeExecuteData = json.decode(json.encode(executeData));
              if (decodeExecuteData.containsKey('week $currentWeek')) {
                Map<Object?, Object?>  currentWeekData = executeData['week $currentWeek'] as Map<Object?, Object?> ;
                Map<String, dynamic> decodeCurrentWeekData = json.decode(json.encode(currentWeekData));
                if (decodeCurrentWeekData.containsKey('progress')) {
                  Map<Object?, Object?> progressData = currentWeekData['progress'] as Map<Object?, Object?>;
                  Map<String, dynamic> decodeProgressData = json.decode(json.encode(progressData));

                  String? username = decodePersonalData['username'] as String?;
                  String? faculty = decodePersonalData['faculty'] as String?;
                  int? totalCalories = decodeProgressData['countTotalCalories'] as int?;
                  Student student = Student(uid: userId, username: username, faculty: faculty, countTotalCalories: totalCalories);
                  students.add(student);
                }
              }
            }
          }
        }
      } catch (e) {
        print('Error: $e');
      }
      yield students;
    }
  }

  // Delete student data
  Future<void> deleteStudentData(String userId) async {
    try {
      await studentReference.child('students/$userId').remove();
    } catch (e) {
      print(e.toString());
    }
  }
  
  // Store student data
  Future<void> storeStudentExerciseData(String userId, String exerciseId, int currentWeek, int currentDay, Map<String, dynamic> exerciseData) async {
    try {
      await studentReference.child('students/$userId/execute/week $currentWeek/day $currentDay/$exerciseId').update(exerciseData);
    } catch (e) {
      print('Error storing student exercise data: $e');
      rethrow;
    }
  }

  // 
  Future<void> updateProgress(String userId, int currentWeek, int currentDay, int overallTotalExercise, int overallTotalTime, int overallTotalCalories) async {
    try {
      await studentReference.child('students/$userId/execute/week $currentWeek/day $currentDay/Goals').update({
        'countTotalExercise': overallTotalExercise,
        'countTotalTime': overallTotalTime,
        'countTotalCalories': overallTotalCalories,
      });
    } catch (e) {
      print(e);
    }
  }

  // Update target for current day
  Future<void> updateTarget(String userId, int currentWeek, int currentDay, int totalExercise, double totalTime, int totalCalories) async {
    try {
      await studentReference.child('students/$userId/execute/week $currentWeek/day $currentDay/Goals').update({
        'countTotalExercise': totalExercise,
        'countTotalTime': totalTime,
        'countTotalCalories': totalCalories,
      });
    } catch (e) {
      print(e);
    }
  }

  // Add target for current day
  Future<void> addTarget(String userId, int currentWeek, int currentDay, String totalExercise, String totalTime, String totalCalories) async {
    try {
      await studentReference.child('students/$userId/execute/week $currentWeek/day $currentDay/Goals').update({
        'targetNoOfExercise': totalExercise,
        'targetTimeSpent': totalTime,
        'targetCaloriesBurned': totalCalories,
      });
    } catch (e) {
      print(e);
    }
  }

  // Shifting week from n to n+1
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

  // Move data from n to n+1
  Future<void> moveData(String userId, int index, int destinationIndex) async {    
    // Source path
    final event = await studentReference.child('students/$userId/execute/week $index').once();
    if (event.snapshot.value != null) {
      // Destination path
      await studentReference.child('students/$userId/execute/week $destinationIndex').set(event.snapshot.value);
      await studentReference.child('students/$userId/execute/week $index').remove();
    }
  }

  // Remove data starting from n-1 to n-3
  Future<void> removeData(String userId, int index) async {
    // Get total weeks
    int weekIndex = execution.getCurrentWeek();
    int weekTotal = execution.getTotalWeeks();
    int firstWeek = (weekIndex - weekTotal) + 1;
    print('First week: $firstWeek');
    
    // Remove 
    await studentReference.child('students/$userId/execute/week $index').remove();
  }

  // Get length of data in database
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
