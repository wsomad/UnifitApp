import 'package:mhs_application/models/date.dart';
import 'package:mhs_application/models/exercise.dart';

class ExerciseExecution extends Exercise {
  Date? date;
  double? totalTime = 0;

  ExerciseExecution({
    String? exerciseId,
    String? exerciseName,
    //Date? executionDate,
    this.totalTime,
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
    };
  }

  factory ExerciseExecution.fromJson(Map<String, dynamic> fromJson) {
    return ExerciseExecution(
      exerciseId: fromJson['id'],
      exerciseName: fromJson['name'],
      totalTime: fromJson['totalTime'],
      //executionDate: Date.fromJson(fromJson['date'] as Map<String, dynamic>),
    );
  }

  int getCurrentWeek() {
    DateTime now = DateTime.now();
    int totalDays = now.difference(DateTime(now.year, 1, 1)).inDays;
    print('total days $totalDays');
    print(((totalDays - 1) ~/ 7) % 4 + 1);
    return ((totalDays - 1) ~/ 7) % 4 + 1;
  }

  void updateCurrentWeek() {
    date?.week = getCurrentWeek();
  }
}
