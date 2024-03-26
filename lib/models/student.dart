import 'package:mhs_application/models/date.dart';

class Student {

  // Declare variables
  String? uid;
  String? email;
  String? password;
  String? username;
  String? gender;
  Date? dateOfBirth;
  double? weight;
  double? height;
  String? faculty;
  double? bmi;
  String? targetNoOfExercise;
  String? targetTimeSpent;
  String? targetCaloriesBurned;
  int? countTotalExercise;
  int? countTotalTime;
  int? countTotalCalories;
  int? leaderboardRank;
  
  // Create a constructor
  Student({
    this.uid,
    this.email,
    this.password,
    this.username,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.faculty,
    this.bmi,
    this.targetNoOfExercise,
    this.targetTimeSpent,
    this.targetCaloriesBurned,
    this.countTotalExercise,
    this.countTotalTime,
    this.countTotalCalories,
  });

  // (Json Serialization)
  // Converting Students dart object into JSON format
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'username': username,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toJson(),
      'weight': weight,
      'height': height,
      'faculty': faculty,
      'bmi': bmi,
      'targetNoOfExercise': targetNoOfExercise,
      'targetTimeSpent': targetTimeSpent,
      'targetCaloriesBurned': targetCaloriesBurned,
      'countTotalExercise': countTotalExercise,
      'countTotalTime': countTotalTime,
      'countTotalCalories': countTotalCalories,
    };
  }

  // (Json Deserialization)
  // Converting Students dart object from JSON format
  factory Student.fromJson(Map<String, dynamic> fromJson) {
    return Student(
      uid: fromJson['uid'] != null 
        ? fromJson['uid'] as String 
        : null,
      email: fromJson['email'] != null 
        ? fromJson['email'] as String 
        : null,
      password: fromJson['password'] != null 
        ? fromJson['password'] as String 
        : null,
      username: fromJson['username'],
      gender: fromJson['gender'] != null 
        ? fromJson['gender'] as String 
        : null,
      dateOfBirth: fromJson['dateOfBirth'] != null 
        ? Date.fromJson(fromJson['dateOfBirth'] as Map<String, dynamic>) 
        : null,
      weight: fromJson['weight'] != null 
        ? (fromJson['weight'] as num?)?.toDouble() ?? 0
        : null,
      height: fromJson['height'] != null 
        ? (fromJson['height'] as num?)?.toDouble() ?? 0 
        : null,
      faculty: fromJson['faculty'] != null 
        ? fromJson['faculty'] as String 
        : null,
      bmi: fromJson['bmi'] != null 
        ? (fromJson['bmi'] as num?)?.toDouble() ?? 0
        : null,
      targetNoOfExercise: fromJson['targetNoOfExercise'],
      targetTimeSpent: fromJson['targetTimeSpent'],
      targetCaloriesBurned: fromJson['targetCaloriesBurned'],
      countTotalExercise: fromJson['countTotalExercise'],
      countTotalTime: fromJson['countTotalTime'],
      countTotalCalories: fromJson['countTotalCalories'],
    );
  }

  String determineBMI(double bmi) {
    String category;

    if (bmi < 18.5) {
      category = 'Underweight';
    } 
    else if (bmi >= 18.5 && bmi < 25) {
      category = 'Normal';
    } 
    else if (bmi >= 25 && bmi < 30) {
      category = 'Overweight';
    } 
    else if (bmi >= 30 && bmi < 35) {
      category = 'Obese';
    }
    else {
      category = 'Extreme Obese';
    }

    return category;
  }
}
