import 'package:flutter/material.dart';
import 'package:mhs_application/screens/secondary/activitiy_screens/activity_collection.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ActivityCollection(),
    );
  }
}