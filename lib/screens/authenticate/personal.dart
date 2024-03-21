// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:mhs_application/models/date.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/services/database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class Personal extends StatefulWidget {

  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final List<String> listOfFaculty = ['FSKM', 'FSG', 'FP'];

  String username = '';
  String selectedGender = '';
  double weight = 0.0;
  double height = 0.0;
  String faculty = '';

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Insert Your Personal Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Username',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Username'),
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Username can't be empty";
                      }
                      return null;
                    },
                    controller: usernameController,
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gender',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedGender = 'Male';
                          });
                        },
                        style: inputSmallButtonDecoration,
                        child: Text(
                          'Male',
                          style: TextStyle(color: greyColor, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedGender = 'Female'; 
                          });
                        },
                        style: inputSmallButtonDecoration,
                        child: Text(
                          'Female',
                          style: TextStyle(color: greyColor, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Date of Birth',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DatePickerWidget(
                    looping: false, // default is not looping
                    firstDate: DateTime(1970, 01, 01),
                    lastDate: DateTime(2030, 1, 1),
                    initialDate: DateTime(1991, 10, 12),
                    dateFormat: "dd-MMM-yyyy",
                    locale: DatePicker.localeFromString('en'),
                    onChange: (DateTime selectedDate, _) {
                      setState(() {
                        studentUser?.dateOfBirth = Date(
                          day: selectedDate.day,
                          month: selectedDate.month,
                          year: selectedDate.year,
                        );
                      });
                    },
                    pickerTheme: DateTimePickerTheme(
                      itemTextStyle: TextStyle(
                        color: greyColor,
                        fontSize: 18,
                      ),
                      confirmTextStyle: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                      ),
                      dividerColor: greenColor,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Weight',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Weight'),
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Weight can't be empty";
                      }
                      return null;
                    },
                    controller: weightController,
                    onChanged: (value) {
                      setState(() {
                        weight = double.parse(value);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Height',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Height'),
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Height can't be empty";
                      }
                      return null;
                    },
                    controller: heightController,
                    onChanged: (value) {
                      setState(() {
                        height = double.parse(value);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Faculty',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButtonFormField(
                    decoration: dropDownDecoration.copyWith(hintText: "Select Faculty"),
                    items: listOfFaculty.map((faculty) {
                      return DropdownMenuItem(
                        value: faculty,
                        child: Text(faculty),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        faculty = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Student student = Student(
                        username: username,
                        gender: selectedGender,
                        dateOfBirth: studentUser?.dateOfBirth,
                        weight: weight,
                        height: height,
                        faculty: faculty,
                      );

                      await _databaseService.updateData('students/${studentUser!.uid}/personal', student.toJson());

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const BottomNavigationBarShared()),
                      );
                    },
                    style: inputLargeButtonDecoration,
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: whiteColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
