import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class CustomValidationDialog extends StatelessWidget {
  final VoidCallback onYesPressed;
  final String title;
  final String message;

  const CustomValidationDialog({
    super.key,
    required this.onYesPressed,
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
            style: const TextStyle(fontSize: 15,),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: inputTinyButtonDecoration,
          child: Text(
            'No',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onYesPressed();
            Navigator.of(context).pop();
          },
          style: inputTinyButtonDecoration,
          child: Text(
            'Yes',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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