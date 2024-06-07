import 'package:flutter/material.dart';
import 'package:mhs_application/models/badges.dart';
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
  double? countTotalTime;
  int? countTotalCalories;
  int? leaderboardRank;
  List<Badges>? badge;
  String? profile;
  
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
    this.badge,
    this.profile,
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
      'badge': badge?.map((badge) => badge.toJson()).toList(),
      'profile': profile,
    };
  }

  // (Json Deserialization)
  // Converting Students dart object from JSON format
  factory Student.fromJson(Map<String, dynamic> fromJson) {
    
    var badgeData = fromJson['badge'];
    List<dynamic> badges = [];

    if (badgeData is Map<String, dynamic>) {
      // Convert Map to List
      badges = badgeData.values.toList();
    } else if (badgeData is List) {
      badges = badgeData;
    }

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
        ? (fromJson['bmi'] as num?)?.toDouble() ?? 0.0
        : null,
      targetNoOfExercise: fromJson['targetNoOfExercise'],
      targetTimeSpent: fromJson['targetTimeSpent'],
      targetCaloriesBurned: fromJson['targetCaloriesBurned'],
      countTotalExercise: fromJson['countTotalExercise'],
      countTotalTime: fromJson['countTotalTime'] != null 
      ? (fromJson['countTotalTime'] as num?)?.toDouble() ?? 0.0
        : null,
      countTotalCalories: fromJson['countTotalCalories'],
      badge: (fromJson['badge'] as List<dynamic>?)
          ?.map((badge) => Badges.fromJson(badge as Map<String, dynamic>))
          .toList(),
      profile: fromJson['profile'],
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
