// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhs_application/models/date.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/primary/bottom_navigation_bar.dart';
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
  int currentWeek = ExerciseExecution().getCurrentWeek();

  String username = '';
  String selectedGender = '';
  double weight = 0.0;
  double height = 0.0;
  String faculty = '';

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.person_2_rounded,
                            color: greyColor,
                          ),
                          hintText: 'Username'),
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
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Gender',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                          style: selectedGender == 'Male'
                              ? inputSmallButtonDecoration.copyWith(
                                  backgroundColor: MaterialStatePropertyAll(
                                      greenColor), // Change color to green when selected
                                )
                              : inputSmallButtonDecoration.copyWith(
                                  backgroundColor: MaterialStatePropertyAll(
                                    grey100Color,
                                  ), // Change color to green when selected
                                ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Male',
                                style: TextStyle(
                                    color: selectedGender == 'Male'
                                        ? whiteColor
                                        : greenColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.male_rounded,
                                color: selectedGender == 'Male'
                                    ? whiteColor
                                    : greenColor,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedGender = 'Female';
                            });
                          },
                          style: selectedGender == 'Female'
                              ? inputSmallButtonDecoration.copyWith(
                                  backgroundColor: MaterialStatePropertyAll(
                                    greenColor,
                                  ), // Change color to green when selected
                                )
                              : inputSmallButtonDecoration.copyWith(
                                  backgroundColor: MaterialStatePropertyAll(
                                    grey100Color,
                                  ), // Change color to green when selected
                                ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Female',
                                style: TextStyle(
                                    color: selectedGender == 'Female'
                                        ? whiteColor
                                        : greenColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.female_rounded,
                                color: selectedGender == 'Female'
                                    ? whiteColor
                                    : greenColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Date of Birth',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: DatePickerWidget(
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
                              color: greenColor,
                              fontSize: 18,
                              fontFamily:
                                  GoogleFonts.rudaTextTheme().toString()),
                          confirmTextStyle: TextStyle(
                            color: greenColor,
                            fontSize: 18,
                          ),
                          dividerColor: greenColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Weight (kg)',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.monitor_weight_outlined,
                            color: greyColor,
                          ),
                          hintText: 'Weight'),
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Weight can't be empty";
                        }
                        return null;
                      },
                      controller: weightController,
                      onChanged: (value) {
                        setState(() {
                          try {
                            weight = double.parse(value);
                          } catch (e) {
                            // Jika nilai tidak sah, tetapkan weight ke nilai default atau lakukan apa-apa tindakan yang sesuai
                            weight = 0.0; // Contoh: tetapkan ke 0.0
                            print('Invalid input for weight: $value');
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Height (cm)',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.height_rounded,
                            color: greyColor,
                          ),
                          hintText: 'Height'),
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
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Faculty',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DropdownButtonFormField(
                      decoration: dropDownDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.school_rounded,
                            color: greyColor,
                          ),
                          hintText: 'Select Faculty'),
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
                        if (_formKey.currentState!.validate()) {
                          if (weightController.text.isNotEmpty &&
                              heightController.text.isNotEmpty) {
                            double height = double.parse(heightController.text);
                            double heightConvert = height / 100;
                            double weight = double.parse(weightController.text);
                            double bmi =
                                weight / (heightConvert * heightConvert);
                            DatabaseReference ref = FirebaseDatabase.instance.ref(
                                'students/${studentUser!.uid}/execute/week $currentWeek/progress');
                            await ref.update({
                              'bmi': bmi,
                            });
                          }

                          Student student = Student(
                            username: username,
                            gender: selectedGender,
                            dateOfBirth: studentUser?.dateOfBirth,
                            weight: weight,
                            height: height,
                            faculty: faculty,
                          );

                          await _databaseService.updateData(
                              'students/${studentUser!.uid}/personal',
                              student.toJson());

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigationBarShared()),
                          );
                        }
                      },
                      style: inputLargeButtonDecoration,
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
