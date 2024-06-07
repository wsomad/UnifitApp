import 'package:flutter/material.dart';
import 'package:mhs_application/shared/custom_bmi_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BMIWeeklyDialog {
  static Future<void> initializeDialogState(BuildContext context, int currentWeek, int previousWeek, int day, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dialogShown = prefs.getBool('isDialogShown_$userId') ?? false;

    if (!dialogShown && currentWeek != previousWeek && day == 1) {
      await _showDialog(context);
      await _setDialogShown(true, userId);
    }
  }

  static Future<void> _setDialogShown(bool value, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDialogShown_$userId', value);
  }

  static Future<void> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CustomInputDialog(
          title: 'Weekly Requirement',
          message: 'Kindly update your weight',
        );
      },
    );
  }
}
