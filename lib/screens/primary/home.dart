// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/authenticate/sign_in.dart';
import 'package:mhs_application/screens/authenticate/sign_up.dart';
import 'package:mhs_application/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student?>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              bool result = await AuthService().signOut();
              
              if (result) {
                print("Home: This is ${studentUser}");
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                }
              }
              else {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                }
              }
              
            }, 
            child: const Text('out')),
        ),
        ),
        
    );
  }
}
