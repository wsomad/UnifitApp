import 'package:flutter/material.dart';
import 'package:mhs_application/components/activity_components/bmi_progression.dart';
import 'package:mhs_application/components/activity_components/calories_burned_progression.dart';
import 'package:mhs_application/components/activity_components/exercise_progression.dart';
import 'package:mhs_application/components/activity_components/time_spent_progression.dart';
import 'package:mhs_application/shared/constant.dart';

class Progression extends StatefulWidget {
  final String typeofProgression;

  const Progression({super.key, required this.typeofProgression});

  @override
  State<Progression> createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {

  late Widget selector;

  Widget determineProgression() {
    if (widget.typeofProgression == 'bmi') {
      selector = const BMIProgression();
    }
    else if (widget.typeofProgression == 'exercise') {
      selector = const ExerciseProgression();
    }
    else if (widget.typeofProgression == 'timeSpent') {
      selector = const TimeSpentProgression();
    }
    else if (widget.typeofProgression == 'calories') {
      selector = const CaloriesBurnedProgression();
    }
    return selector;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: greenColor,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Weekly Progression',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Text('      '),
                  ],
                ),
              ],
            ),
          ),
          determineProgression(),
        ],
      ),
    );
  }
}