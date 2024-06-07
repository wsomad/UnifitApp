// ignore_for_file: avoid_print

import 'package:mhs_application/models/date.dart';
import 'package:mhs_application/models/exercise.dart';

class ExerciseExecution extends Exercise {
  Date? date;
  DateTime? timestamp;
  double? totalTime = 0;
  String? targetNoOfExercise;
  String? targetTimeSpent;
  String? targetCaloriesBurned;

  ExerciseExecution({
    String? exerciseId,
    String? exerciseName,
    //Date? executionDate,
    DateTime? timestamp,
    this.totalTime,
    this.targetNoOfExercise,
    this.targetTimeSpent,
    this.targetCaloriesBurned,
  }) : super(
          id: exerciseId,
          name: exerciseName,
        ) {
    //date = executionDate ?? Date();
  }

  Map<String, dynamic> toJsonDate() {
    return {
      'id': id,
      'name': name,
      'totalTime': totalTime,
      //'date': date?.toJson(),
      'targetNoOfExercise': targetNoOfExercise,
      'targetTimeSpent': targetTimeSpent,
      'targetCaloriesBurned': targetCaloriesBurned,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  factory ExerciseExecution.fromJson(Map<String, dynamic> fromJson) {
    return ExerciseExecution(
      exerciseId: fromJson['id'],
      exerciseName: fromJson['name'],
      totalTime: fromJson['totalTime'],
      //executionDate: Date.fromJson(fromJson['date'] as Map<String, dynamic>),
      targetNoOfExercise: fromJson['targetNoOfExercise'],
      targetTimeSpent: fromJson['targetTimeSpent'],
      targetCaloriesBurned: fromJson['targetCaloriesBurned'],
      timestamp: fromJson['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(fromJson['timestamp'])
          : null,
    );
  }

  bool isSameDay(DateTime date) {
    return date.year == timestamp?.year &&
        date.month == timestamp?.month &&
        date.day == timestamp?.day;
  }

  int getCurrentWeek() {
    DateTime now = DateTime.now();
    // Find the nearest Monday to January 1st of the current year
    DateTime jan1 = DateTime(now.year, 1, 1);
    DateTime nearestMonday = jan1.subtract(Duration(days: jan1.weekday - 1));
    if (jan1.weekday > DateTime.monday) {
      nearestMonday = nearestMonday.add(const Duration(days: 7));
    }
    // Calculate the week number
    int weekNumber = ((now.difference(nearestMonday).inDays) / 7).floor() + 1;
    print('Current week: $weekNumber');
    return weekNumber;
  }

  DateTime getCurrentWeekStart() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  DateTime getCurrentWeekEnd() {
    DateTime now = DateTime.now();
    DateTime endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    return DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
  }

  int getTotalWeeks() {
    DateTime now = DateTime.now();
    int totalDays = now.difference(DateTime(now.year, 1, 1)).inDays;
    int totalWeeks = (totalDays ~/ 7) % 4 + 1; // Adding 1 to start the week count from 1
    return totalWeeks;
  }

  int getPreviousWeek() {
    int currentWeek = getCurrentWeek();
    int previousWeek = currentWeek - 1;
    if (previousWeek == 0) {
      previousWeek = 13;
    }
    return previousWeek;
  }
}
