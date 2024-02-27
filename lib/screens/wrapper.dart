// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/authenticate/authentication.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // Retrieving Student object from nearest  
    final studentUser = Provider.of<Student?>(context);
    print("Wrapper: This is ${studentUser?.uid}");

    if (studentUser == null) {
      return const Authentication();
    } 
    else {
      return const BottomNavigationBarShared();
    }    
  }
}
