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
    int totalDays = now.difference(DateTime(now.year, 1, 1)).inDays;
    print('Current week: Week ${((totalDays - 0) ~/ 7) % 4 + 1}');
    return ((totalDays - 0) ~/ 7) % 4 + 1;
  }

  int getTotalWeeks() {
    DateTime now = DateTime.now();
    int totalDays = now.difference(DateTime(now.year, 1, 1)).inDays;
    int totalWeeks = (totalDays ~/ 7) % 4 + 1; // Adding 1 to start the week count from 1
    return totalWeeks;
  }

  void updateCurrentWeek() {
    date?.week = getCurrentWeek();
  }
}
