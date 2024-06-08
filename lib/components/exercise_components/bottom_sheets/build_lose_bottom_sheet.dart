import 'package:flutter/material.dart';
import 'package:mhs_application/components/custom_dialogs/custom_alert_dialog.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/build_lose_execution.dart';
import 'package:mhs_application/shared/constant.dart';

class BuildLoseBottomSheet extends StatefulWidget {
  final String programName;
  final Exercise selectedExercise;
  final int sets;
  final int reps;
  final String type;
  final String image;

  const BuildLoseBottomSheet({
    super.key,
    required this.programName,
    required this.selectedExercise,
    required this.sets,
    required this.reps,
    required this.type,
    required this.image,
  });

  @override
  State<BuildLoseBottomSheet> createState() => _BuildLoseBottomSheetState();
}

class _BuildLoseBottomSheetState extends State<BuildLoseBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _repController = TextEditingController();

  int rep = 0;
  int set = 0;

  void determineProgram() {
    if (widget.type == 'Muscle Building') {
      setState(() {
        set = widget.sets;
        rep = widget.reps;
        print('$set $rep');
      });
    } else if (widget.type == 'Weight Loss') {
      setState(() {
        set = widget.sets;
        rep = widget.reps;
        print('$set $rep');
      });
    }
  }

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Set',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _repController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        set = int.parse(value);
                      }
                    },
                    decoration: textInputDecoration.copyWith(
                      hintText:
                          widget.type == 'Muscle Building' ? 'Recommended: 3-6' : 'Recommended: 6-12',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Rep',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _setController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        rep = int.parse(value);
                      }
                    },
                    decoration: textInputDecoration.copyWith(
                      //suffixText: 'No. of set(s)',
                      hintText:
                          widget.type == 'Muscle Building' ? 'Recommended: 6-12' : 'Recommended: 10-15',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
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
                    if (set == 0 || rep == 0) {
                      // Show a warning to the user
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomAlertDialog(
                            title: 'Warning',
                            message:
                                "You can't proceed by leaving your set or rep empty.",
                          );
                        },
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuildLoseExecution(
                            programName: widget.programName,
                            selectedExercise: widget.selectedExercise,
                            rep: rep,
                            set: set,
                            image: widget.image,
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
}
