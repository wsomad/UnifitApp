// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/authenticate/authentication.dart';
import 'package:mhs_application/screens/primary/bottom_navigation_bar.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadingStartUp();
  }

  Future<void> _loadingStartUp() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieving Student object from nearest
    final studentUser = Provider.of<Student?>(context);
    print("Wrapper: Hello ${studentUser?.uid}!");

    if (_isLoading) {
      return startUpScreen();
    }

    if (studentUser == null) {
      return const Authentication();
    } else {
      return const BottomNavigationBarShared();
    }
  }

  Widget startUpScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/unifit_logo.png', height: 80),
            const SizedBox(height: 30),
            SpinKitChasingDots(
              color: greenColor,
            ),
          ],
        ),
      ),
    );
  }
}
