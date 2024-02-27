import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class RestBottomSheet extends StatefulWidget {
  const RestBottomSheet({super.key});

  @override
  State<RestBottomSheet> createState() => _RestBottomSheetState();
}

class _RestBottomSheetState extends State<RestBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int seconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    seconds = 30; // Initial rest time in seconds
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'You have paused',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _formatDuration(Duration(seconds: seconds)),
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      seconds += 11;
                    });
                  },
                  style: inputSmallButtonDecoration.copyWith(
                      backgroundColor: MaterialStatePropertyAll(greenColor),
                      side: MaterialStatePropertyAll(
                        BorderSide(color: greenColor, width: 2.0),
                      )),
                  child: Text(
                    'Increase by 10s',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: inputSmallButtonDecoration.copyWith(
                      backgroundColor: MaterialStatePropertyAll(greenColor)),
                  child: Text(
                    'Done & Proceed',
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        }
      });
    });
  }
}
