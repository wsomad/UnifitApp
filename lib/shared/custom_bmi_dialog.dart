import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class CustomInputDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomInputDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);
    TextEditingController weightController = TextEditingController();
    int currentWeek = ExerciseExecution().getCurrentWeek();

    return StreamBuilder<Student>(
        stream: StudentDatabaseService()
            .readCurrentStudentData('${studentUser?.uid}', 'personal'),
        builder: (context, snapshot) {
          final data = snapshot.data;
          var height = data?.height ?? 0;
          var studentHeightMeter = height / 100;
          print(height);

          return AlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Inseft your new weight (kg)',
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (weightController.text.isEmpty || double.parse(weightController.text) <= 0) {
                      // Show an error message if weight is not provided or less than or equal to 0
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid weight.'),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    } 
                    else {
                      double weight = double.parse(weightController.text);
                      double bmi =
                          weight / (studentHeightMeter * studentHeightMeter);
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          'students/${studentUser?.uid}/execute/week $currentWeek/progress');
                      await ref.update({
                        'bmi': bmi,
                      });
                      DatabaseReference ref2 = FirebaseDatabase.instance.ref(
                          'students/${studentUser?.uid}/execute/week $currentWeek/progress');
                      await ref2.update({
                        'weight': weight,
                      });
                      DatabaseReference ref3 = FirebaseDatabase.instance
                          .ref('students/${studentUser?.uid}/personal');
                      await ref3.update({
                        'weight': weight,
                      });
                    }

                    Navigator.of(context).pop();
                  },
                  style: inputLargeButtonDecoration,
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        });
  }
}
