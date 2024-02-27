import 'package:flutter/material.dart';
import 'package:mhs_application/screens/authenticate/sign_in.dart';
import 'package:mhs_application/screens/authenticate/sign_up.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return const SignIn();
    }
    else {
      return const SignUp();
    }
  }
}
