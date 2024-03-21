import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: inputLargeButtonDecoration,
            child: Text(
              'OK',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
