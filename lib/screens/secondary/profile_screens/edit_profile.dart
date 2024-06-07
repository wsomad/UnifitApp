import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student>(context);
    TextEditingController usernameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    int currentWeek = ExerciseExecution().getCurrentWeek();

    return StreamBuilder<Student>(
      stream: StudentDatabaseService().readCurrentStudentData(
          '${studentUser.uid}', 'personal'),
      builder: (context, snapshot) {
        final personalData = snapshot.data;
        var weight = personalData?.weight ?? 0.0;
        var height = personalData?.height ?? 1.0;
        var bmi = weight / (height / 100 * height / 100);
        var day = personalData?.dateOfBirth?.day ?? 1;
        var month = personalData?.dateOfBirth?.month ?? 1;
        var year = personalData?.dateOfBirth?.year ?? 2000;

        return Scaffold(
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: greenColor,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              'Edit Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Text('      '),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: greenColor,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 1,
                          controller: usernameController,
                          decoration: textInputDecoration.copyWith(
                            hintText: personalData?.username,
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school_rounded,
                              color: greenColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Faculty',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 1,
                          readOnly: true,
                          decoration: textInputDecoration.copyWith(
                            hintText: personalData?.faculty,
                            fillColor: grey100Color,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: grey100Color)),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              color: greenColor,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: grey100Color,
                              ),
                              child: Center(
                                child: Text(
                                  day.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600]
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              child: Text(
                                '-',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: grey100Color,
                              ),
                              child: Center(
                                child: Text(
                                  month.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600]
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              child: Text(
                                '-',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: grey100Color,
                              ),
                              child: Center(
                                child: Text(
                                  year.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people_alt_rounded,
                              color: greenColor,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Gender',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 1,
                          readOnly: true,
                          decoration: textInputDecoration.copyWith(
                            hintText: (personalData?.gender),
                            fillColor: grey100Color,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: grey100Color)),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.monitor_weight_outlined,
                              color: greenColor,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Weight (kg)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 1,
                          controller: weightController,
                          decoration: textInputDecoration.copyWith(
                            hintText: (personalData?.weight)?.toStringAsFixed(2),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.height_rounded,
                              color: greenColor,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Height (cm)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 1,
                          readOnly: true,
                          controller: heightController,
                          decoration: textInputDecoration.copyWith(
                            hintText: (personalData?.height)?.toStringAsFixed(2),
                            fillColor: grey100Color,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: grey100Color)),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.accessibility_new_rounded,
                              color: greenColor,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'BMI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 1,
                          readOnly: true,
                          decoration: textInputDecoration.copyWith(
                            hintText: bmi.toStringAsFixed(2),
                            fillColor: grey100Color,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: grey100Color)),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DatabaseReference databaseReference = FirebaseDatabase
                            .instance
                            .ref('students/${studentUser.uid}/personal');

                        DatabaseReference ref = FirebaseDatabase.instance.ref(
                            'students/${studentUser.uid}/execute/week $currentWeek/progress');

                        if (usernameController.text.isNotEmpty) {
                          await databaseReference.update({
                            'username': usernameController.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Username successfully updated.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }

                        if (weightController.text.isNotEmpty) {
                          double weight = double.parse(weightController.text);
                          await databaseReference.update({
                            'weight': weight,
                          });
                          double bmi =
                              weight / ((height / 100) * (height / 100));
                          await ref.update({
                            'bmi': bmi,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Weight successfully updated.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      style: inputLargeButtonDecoration,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int getDaysInMonth(int month, int year) {
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    return lastDayOfMonth.day;
  }

  Widget buildTimeDropdown(
      int selectedValue, int maxValue, ValueChanged? onChanged) {
    return SizedBox(
      width: 90.0,
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        items: List.generate(maxValue, (index) {
          return DropdownMenuItem<int>(
            value: index,
            child: Text(
              (index + 1).toString().padLeft(2, '0'),
            ),
          );
        }),
        onChanged: onChanged,
        decoration: textInputDecoration.copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        ),
      ),
    );
  }
}
