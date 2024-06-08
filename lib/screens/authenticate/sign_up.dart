// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/authenticate/personal.dart';
import 'package:mhs_application/screens/authenticate/sign_in.dart';
import 'package:mhs_application/services/auth.dart';
import 'package:mhs_application/shared/constant.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String email = '';
  String password = '';
  String confirmPassword = '';

  var currentState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 230,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: Center(
                            child: Image(
                              image: AssetImage(
                                'assets/images/unifit_logo.png',
                              ),
                              height: 100,
                              width: 250,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Create Account Now to Start.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: greyColor,
                        ),
                        hintText: 'Email'),
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Email can't be empty";
                      }
                      return null;
                    },
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.key_rounded,
                          color: greyColor,
                        ),
                        hintText: 'Password'),
                    validator: (String? value) {
                      if (value!.length < 6) {
                        return "Password must be length than 6 characters";
                      } else if (value.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Confirm Password',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.key_rounded,
                          color: greyColor,
                        ),
                        hintText: 'Confirm Passowrd'),
                    validator: (String? value) {
                      if (value != password) {
                        return "Password is not matched";
                      } else if (value!.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        currentState = _formKey.currentState;
                        if (currentState != null) {
                          currentState.validate();
                          currentState.save();
                          Student student = Student(
                            email: email,
                            password: password,
                          );
                          dynamic result =
                              await _authService.signUpWithEmailAndPassword(
                                  email, password, student);
                          if (result == null) {
                            print("Failed to sign up.");
                          } else {
                            print("Successfully signed up!");
                            print("Current User: " + result.uid);
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Personal()),
                              );
                            }
                          }
                        }
                      },
                      style: inputLargeButtonDecoration,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: blackColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()),
                            );
                          },
                          child: Text(
                            " Sign In",
                            style: TextStyle(
                                color: greenColor,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
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
