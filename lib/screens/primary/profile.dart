import 'package:flutter/material.dart';
import 'package:mhs_application/screens/secondary/profile_screens/profile_details.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: ProfileDetails(),
    );
  }
}
