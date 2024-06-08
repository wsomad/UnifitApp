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

/*
  // Read all student rank data
  Stream<List<Student>> readAllStudentsRank(String sourcePath) async* {
    var ref = studentReference.child(sourcePath);

    await for (var event in ref.onValue) {
      List<Student> students = [];
      try {
        for (final child in event.snapshot.children) {
          if (child.value != null) {
            Map<Object?, Object?> rawData = child.value as Map<Object?, Object?>;
            Map<String, dynamic> data = json.decode(json.encode(rawData));
            //print('Raw Data: $rawData');
            print('Decoded Data: $data');
            students.add(Student.fromJson(data));
          }
        }
      } catch (e) {
        print('Error: $e');
      }
      yield students;
    }
  }*/

  Stream<Student> readStudentBadges(String userId, String sourcePath) async* {
    var ref = studentReference.child('students/$userId/$sourcePath');
    List<Student> students = [];

    try {
      List<Badges> badges = [];

      await for (var event in ref.onValue) {
        for (final child in event.snapshot.children) {
          if (child.value != null) {
            Map<Object?, Object?> userData = child.value as Map<Object?, Object?>;
            Map<String, dynamic> badge = json.decode(json.encode(userData));
            print('User data: $userData');
            print('Badge: $badge');

            String badgeID = badge['badgeID'];
            print('Badge ID: $badgeID');
            String badgeName = badge['badgeName'];
            print('Badge Name: $badgeName');
            String badgeImagePath = badge['badgeImagePath'];
            print('Badge Image: $badgeImagePath');
            String badgeType = badge['badgeType'];
            print('Badge Type: $badgeType');

            // Create a Badges object for each badge
            Badges badge2 = Badges(
              badgeID: badgeID,
              badgeName: badgeName,
              badgeImagePath: badgeImagePath,
              badgeType: badgeType,
            );
            // Add the badge to the list
            badges.add(badge2);

            /*
            List<Badges> badgesList = [];
            badge.forEach((key, value) {
              // Extract badge details from each entry
              String badgeID = value['badgeID'];
              String badgeName = value['badgeName'];
              String badgeImagePath = value['badgeImagePath'];
              String badgeType = value['badgeType'];

              // Create a Badges object for each badge
              Badges badge = Badges(
                badgeID: badgeID,
                badgeName: badgeName,
                badgeImagePath: badgeImagePath,
                badgeType: badgeType,
              );
              print(badge);
              // Add the badge to the list
              badgesList.add(badge);
            });
            */

            // Create a Student object with the retrieved data
            //Student student = Student(badge: badges);
            //students.add(student);
            //yield Student(badge: [badge2]);

            /*
            if (userData != null && userData.containsKey('badge')) {

              Map<Object?, Object?> badgeData = userData['badge'] as Map<Object?, Object?>;
              Map<String, dynamic> badge = json.decode(json.encode(badgeData));
              print('Check badge: $badge');

              if (badge != null && badge.containsKey('week $currentWeek')) {

                Map<Object?, Object?>  currentWeekData = badge['week $currentWeek'] as Map<Object?, Object?> ;
                Map<String, dynamic> week = json.decode(json.encode(currentWeekData));
                print('Check week: $week');

                if (week != null && week.containsKey('badge')) {

                  Map<Object?, Object?> progressData = week['badge'] as Map<Object?, Object?>;
                  Map<String, dynamic> badge2 = json.decode(json.encode(progressData));
                  print('Check badge2: $badge2');

                  if (badge2 != null) {
                    
                    
                  }
                }
              }
              else {
                print('No data for week $currentWeek for user: $userId');
                
              }
            }*/
          }
        }
        if (badges.isNotEmpty) {
        // If badges are collected, yield a single Student object containing all badges
        yield Student(badge: badges);
      }
      }/*
      if (badges.isNotEmpty) {
        // If badges are collected, yield a single Student object containing all badges
        yield Student(badge: badges);
      }*/
    } catch (e) {
      print('Error: $e');
    }
    //yield students;
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
        print('$weekKey $bmi');
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

            if (userData != null && userData.containsKey('personal')) {
              Map<Object?, Object?> personalData = userData['personal'] as Map<Object?, Object?>;
              Map<String, dynamic> data = json.decode(json.encode(personalData));
              Map<Object?, Object?> executeData = userData['execute'] as Map<Object?, Object?>;
              Map<String, dynamic> data1 = json.decode(json.encode(executeData));
              if (data1 != null && data1.containsKey('week $currentWeek')) {
                Map<Object?, Object?>  currentWeekData = executeData['week $currentWeek'] as Map<Object?, Object?> ;
                Map<String, dynamic> data2 = json.decode(json.encode(currentWeekData));
                if (data2 != null && data2.containsKey('progress')) {
                  Map<Object?, Object?> progressData = currentWeekData['progress'] as Map<Object?, Object?>;
                  Map<String, dynamic> data3 = json.decode(json.encode(progressData));

                  if (data != null || data1 != null && data2 != null) {
                    String? username = data['username'] as String?;
                    String? faculty = data['faculty'] as String?;
                    int? totalCalories = data3['countTotalCalories'] as int?;

                    // Create a Student object with the retrieved data
                    Student student = Student(uid: userId, username: username, faculty: faculty, countTotalCalories: totalCalories);
                    students.add(student);
                  }
                }
              }
            }
            
            /*
            if (userData != null) {
              Map<Object?, Object?> personalData = userData['personal'] as Map<Object?, Object?>;
              Map<String, dynamic> data1 = json.decode(json.encode(personalData));
              print('Check 1: $data1');
              Map<Object?, Object?> progressData = userData['execute'] as Map<Object?, Object?>;
              Map<String, dynamic> data2 = json.decode(json.encode(progressData));
              print('Check 2: $data2');

              if (data1 != null && data2 != null) {
                String username = data1['username'] as String;
                print('Username: $username');
                String faculty = data1['faculty'] as String;
                int? totalCalories = data2['countTotalCalories'] as int?;
                print('Total Calories: $totalCalories');

                // Create a Student object with the retrieved data
                Student student = Student(uid: userId, username: username, faculty: faculty, countTotalCalories: totalCalories);
                students.add(student);
              }
            }*/
          }
        }
      } catch (e) {
        print('Error: $e');
      }
      yield students;
    }
  }

  /*
  Stream<List<Student>> readAllStudentsData() async* {
    var ref = studentReference.child('students');

    await for (var snapshot in ref.onValue) {
      List<Student> studentsData = [];
      try {
        // Iterate over the children of the 'students' node
        for (var childSnapshot in snapshot.snapshot.children) {
          // Get the user ID (key) of the child node
          var userId = childSnapshot.key;
          
          // Get the value (data) of the child node
          var userData = childSnapshot.value;

          Map<Object?, Object?> rawData = userData as Map<Object?, Object?>;
          Map<String, dynamic> data = json.decode(json.encode(rawData));

          // Add the user ID to the userData map for reference
          data['userId'] = userId;
          print(data['userId']);

          // Add the user data to the list
          studentsData.add(Student.fromJson(data));
        }
      } catch (e) {
        print('Error fetching students data: $e');
      }
      // Yield the list of students' data
      yield studentsData;
    }
  }*/

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
