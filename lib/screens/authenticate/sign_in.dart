// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/screens/authenticate/sign_up.dart';
import 'package:mhs_application/services/auth.dart';
import 'package:mhs_application/shared/constant.dart';

class SignIn extends StatefulWidget {

  //final Function toggleView;

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';

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
                    height: 340,
                    child: Center(
                      child: Text(
                        'You Have Made A Right Choice.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
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
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (String? value) {
                      if (value!.length < 6) {
                        return "Password must be length than 6 characters";
                      }
                      else if (value.isEmpty) {
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
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                        if (result == null) {
                          print("Failed to sign in. User is not exists yet.");
                        }
                        else {
                          print("Successfully signed in!");
                          print("Current User: " + result.uid);
                        }/*
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Home()),
                          );
                        }*/
                      }
                    },
                    style: inputLargeButtonDecoration,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: whiteColor, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have any account?",
                      style: const TextStyle(
                        color: Colors.black, 
                        decoration: TextDecoration.none,
                        fontFamily: 'Ruda' 
                      ),
                      children: [
                        TextSpan(
                          text: " Sign Up",
                          style: const TextStyle(
                            color: Color(0xFF66CC66),
                            decoration: TextDecoration.none,
                            fontFamily: 'Ruda'
                          ),
                          recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUp()),
                            );
                          },
                          /*recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            widget.toggleView();
                          }*/
                        )
                      ]
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
