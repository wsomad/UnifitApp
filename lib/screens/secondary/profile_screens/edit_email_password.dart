import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/auth.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/shared/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

class EditEmailPassword extends StatefulWidget {
  const EditEmailPassword({super.key});

  @override
  State<EditEmailPassword> createState() => _EditEmailPasswordState();
}

class _EditEmailPasswordState extends State<EditEmailPassword> {
  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student>(context);
    final AuthService _authService = AuthService();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    TextEditingController currentPasswordController = TextEditingController();

    return StreamBuilder<Student?>(
      stream: StudentDatabaseService(uid: studentUser.uid)
          .readCurrentStudentData('${studentUser.uid}', 'credential'),
      builder: (context, snapshot) {
        final student = snapshot.data;

        var email = student?.email;
        var password = student?.password;
        
        return Scaffold(
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
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
                              'Email & Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Text(''),
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
                              Icons.email_outlined,
                              color: greenColor,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Email',
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
                            hintText: student?.email,
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
                              Icons.key_off,
                              color: greenColor,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Current Password',
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
                          controller: currentPasswordController,
                          obscureText: false,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Current Password'
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
                              Icons.key,
                              color: greenColor,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'New Password',
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
                          controller: passwordController,
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'New Password'
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
                              Icons.key,
                              color: greenColor,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Confirm New Password',
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
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Confirm New Password'
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
                        if (currentPasswordController.text == password) {
                          if (passwordController.text == confirmPasswordController.text) {
                            _authService.changePassword(email!, passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password successfully updated.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'New password is not matched.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Current password is not matched.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      style: inputLargeButtonDecoration,
                      child: Text(
                        'Update Password',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
