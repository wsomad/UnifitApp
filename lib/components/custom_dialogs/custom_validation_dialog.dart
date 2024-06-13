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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: inputSmallButtonDecoration.copyWith(
                  backgroundColor: MaterialStatePropertyAll(greyColor)
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () async {
                  onYesPressed();
                  Navigator.of(context).pop();
                },
                style: inputSmallButtonDecoration.copyWith(
                  backgroundColor: MaterialStatePropertyAll(greenColor)
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}