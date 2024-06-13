import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambah ni untuk PlatformException
import 'package:mhs_application/screens/authenticate/personal.dart';
import 'package:mhs_application/screens/authenticate/sign_up.dart';
import 'package:mhs_application/services/authentication/auth.dart';
import 'package:mhs_application/screens/primary/bottom_navigation_bar.dart';
import 'package:mhs_application/shared/constant.dart';

class SignIn extends StatefulWidget {
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
  String _errorMessage = '';

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        dynamic result = await _authService.signInWithEmailAndPassword(email, password);
        if (result != null) {
          bool userDetailsFilled = await checkUserDetails(result.uid, 'personal');
          if (!mounted) return;
          if (userDetailsFilled) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigationBarShared(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Personal(),
              ),
            );
          }
        } 
        else {
          setState(() {
            _errorMessage = 'Failed to sign in. User does not exist.';
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_errorMessage),
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } 
        else if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        }
        else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password provided for that user.';
        }
        else {
          errorMessage = 'Failed to sign up. Please try again.';
        }
        setState(() {
          _errorMessage = errorMessage;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An unknown error occurred.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                              "Sign In Now to Continue.",
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
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: greyColor,
                        ),
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty.';
                        } else if (!isEmailValid(value)) {
                          return 'Email is not valid.';
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.key_rounded,
                          color: greyColor,
                        ),
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty.';
                        } else if (value.length < 6) {
                          return "Password can't be less than 6 characters.";
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
                      onPressed: _signIn,
                      style: inputLargeButtonDecoration,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                            "Don't have any account?",
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
                                    builder: (context) => const SignUp()),
                              );
                            },
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                color: greenColor,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }

  Future<bool> checkUserDetails(String userId, String sourcePath) async {
    final path =
        FirebaseDatabase.instance.ref().child('students/$userId/$sourcePath');

    final event = await path.once();
    if (event.snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }
}
