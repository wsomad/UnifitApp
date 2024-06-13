import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/databases/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class CreateGoal extends StatefulWidget {
  final Function(String) addGoal;

  const CreateGoal({
    super.key,
    required this.addGoal,
  });

  @override
  State<CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  List<ExerciseExecution> goals = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);
    var day = DateTime.now().weekday;
    var week = ExerciseExecution().getCurrentWeek();

    return StreamBuilder<Student?>(
      stream: StudentDatabaseService(uid: studentUser!.uid)
          .readCurrentStudentData(
              '${studentUser.uid}', 'execute/week $week/day $day/Goals'),
      builder: (context, snapshot) {
        final student = snapshot.data;
        var targetExerciseValue = student?.targetNoOfExercise ?? '0';
        var targetTimeValue = student?.targetTimeSpent ?? '0';
        var targetCaloriesValue = student?.targetCaloriesBurned ?? '0';

        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  'Set Your Target',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: grey100Color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: greenColor,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'You may have up to three targets at a time',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target No. of Exercise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: exerciseController,
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                      hintText: targetExerciseValue,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target Time Spent (min)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                      hintText: targetTimeValue,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target Calories Burned',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                      hintText: targetCaloriesValue,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  DatabaseReference ref = FirebaseDatabase.instance.ref(
                      'students/${studentUser.uid}/execute/week $week/day $day/Goals');
                  if (_formKey.currentState!.validate()) {
                    if (exerciseController.text.isNotEmpty) {
                      widget.addGoal(exerciseController.text);
                      await ref.update({
                        "targetNoOfExercise": exerciseController.text,
                      });
                    }
                    if (timeController.text.isNotEmpty) {
                      widget.addGoal(timeController.text);
                      await ref.update({
                        "targetTimeSpent": timeController.text,
                      });
                    }
                    if (caloriesController.text.isNotEmpty) {
                      widget.addGoal(caloriesController.text);
                      await ref.update({
                        "targetCaloriesBurned": caloriesController.text,
                      });
                    }
                  }
                },
                style: inputLargeButtonDecoration.copyWith(
                    backgroundColor: MaterialStatePropertyAll(greenColor)),
                child: Text(
                  'Set Target',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
