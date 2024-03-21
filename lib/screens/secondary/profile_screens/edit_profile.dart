import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

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
    TextEditingController facultyController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();

    return StreamBuilder<Student?>(
      stream: StudentDatabaseService(uid: studentUser.uid)
          .readCurrentStudentData('students/${studentUser.uid}/personal'),
      builder: (context, snapshot) {
        final student = snapshot.data;

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
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: greenColor,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
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
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextField(
                          maxLines: 1,
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: student?.username,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
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
                        const Text(
                          'Faculty',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextField(
                          maxLines: 1,
                          controller: facultyController,
                          decoration: InputDecoration(
                            hintText: student?.faculty,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (text) {
                            // Handle the text change
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildTimeDropdown(selectedDay, getDaysInMonth(selectedMonth, selectedYear), (value) {
                          setState(() {
                            selectedDay = value as int;
                          });
                        }),
                        buildTimeDropdown(selectedMonth, 12, (value) {
                          setState(() {
                            selectedMonth = value as int;
                            // Adjust the day dropdown when the month changes
                            selectedDay = selectedDay > getDaysInMonth(selectedMonth, selectedYear) ? 1 : selectedDay;
                          });
                        }),
                        buildTimeDropdown(selectedYear, DateTime.now().year, (value) {
                          setState(() {
                            selectedYear = value as int;
                            // Adjust the day dropdown when the year changes
                            selectedDay = selectedDay > getDaysInMonth(selectedMonth, selectedYear) ? 1 : selectedDay;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),*/
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextField(
                          maxLines: 1,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: (student?.gender),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weight (kg)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextField(
                          maxLines: 1,
                          controller: weightController,
                          decoration: InputDecoration(
                            hintText: (student?.weight)?.toStringAsFixed(2),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
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
                        const Text(
                          'Height (cm)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextField(
                          maxLines: 1,
                          controller: heightController,
                          decoration: InputDecoration(
                            hintText: (student?.height)?.toStringAsFixed(2),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: greenColor, width: 2),
                            ),
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

                        if (usernameController.text.isNotEmpty) {
                          await databaseReference.update({
                            'username': usernameController.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Username successfully updated',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              duration: const Duration(seconds: 5),
                              backgroundColor: greenColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: inputLargeButtonDecoration,
                      child: Text(
                        'Update',
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    )
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
