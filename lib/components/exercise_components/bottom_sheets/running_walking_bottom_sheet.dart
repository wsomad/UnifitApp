import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/models/time.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/running_walking_execution.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/shared/custom_alert_dialog.dart';

class RunningWalkingBottomSheet extends StatefulWidget {
  final String programName;
  final Exercise selectedExercise;
  const RunningWalkingBottomSheet({
    super.key,
    required this.programName,
    required this.selectedExercise,
  });

  @override
  State<RunningWalkingBottomSheet> createState() =>
      _RunningWalkingBottomSheetState();
}

class _RunningWalkingBottomSheetState extends State<RunningWalkingBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeDetails _timeDetails = TimeDetails();
  int selectedHours = 0;
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Set Exercise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Duration',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildTimeDropdown(selectedHours, 24, (value) {
                        setState(() {
                          selectedHours = value as int;
                        });
                      }),
                      buildTimeDropdown(selectedMinutes, 60, (value) {
                        setState(() {
                          selectedMinutes = value as int;
                        });
                      }),
                      buildTimeDropdown(selectedSeconds, 60, (value) {
                        setState(() {
                          selectedSeconds = value as int;
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: inputSmallButtonDecoration.copyWith(
                      backgroundColor: MaterialStatePropertyAll(greyColor),
                      side: MaterialStatePropertyAll(
                        BorderSide(color: greyColor, width: 2.0),
                      )),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Duration: ${selectedHours}hours ${selectedMinutes}min ${selectedSeconds}sec');
                    _timeDetails = TimeDetails(hours: selectedHours,minutes: selectedMinutes, seconds: selectedSeconds);
                    
                    if (selectedHours == 0 && selectedMinutes == 0 && selectedSeconds == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomAlertDialog(
                            title: 'Warning',
                            message: "You can't proceed by leaving your time duration empty.",
                          );
                        },
                      );
                    }
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunningWalkingExecution(
                            programName: widget.programName,
                            selectedExercise: widget.selectedExercise,
                            timeDetails: _timeDetails,
                          ),
                        ),
                      );
                    }
                  },
                  style: inputSmallButtonDecoration.copyWith(
                      backgroundColor: MaterialStatePropertyAll(greenColor)),
                  child: Text(
                    'Start',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTimeDropdown(
      int selectedValue, int maxValue, ValueChanged? onChanged) {
    return SizedBox(
      width: 90.0,
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        items: List.generate(maxValue, (index) {
          return DropdownMenuItem<int>(
            value: index,
            child: Text(
              index.toString().padLeft(2, '0'),
            ),
          );
        }),
        onChanged: onChanged,
        decoration: textInputDecoration.copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
      ),
    );
  }
}
