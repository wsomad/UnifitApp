import 'package:flutter/material.dart';
import 'package:mhs_application/shared/custom_alert_dialog.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/build_lose_execution.dart';
import 'package:mhs_application/shared/constant.dart';

class BuildLoseBottomSheet extends StatefulWidget {
  final Exercise selectedExercise;

  const BuildLoseBottomSheet({super.key, required this.selectedExercise,});

  @override
  State<BuildLoseBottomSheet> createState() => _BuildLoseBottomSheetState();
}

class _BuildLoseBottomSheetState extends State<BuildLoseBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _repController = TextEditingController();

  int rep = 0;
  int set = 0;

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
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Set',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      hintText: 'Number of set(s)',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      hintText: 'Number of rep(s)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
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
                          return const CustomAlertDialog(title: 'Ooops!', message: 'Seems like your set or rep is empty');
                        },
                      );
                    }
                    else {
                      print('$rep reps');
                      print('$set sets');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          BuildLoseExecution(
                            selectedExercise: widget.selectedExercise,
                            rep: rep,
                            set: set,
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