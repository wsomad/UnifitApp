import 'package:flutter/material.dart';
import 'package:mhs_application/screens/authenticate/sign_in.dart';
import 'package:mhs_application/services/authentication/auth.dart';
import 'package:mhs_application/shared/constant.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomDeleteDialog({
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
          fontSize: 18,
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
          ),
        ],
      ),
      actions: [
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
                  dynamic result = await AuthService().deleteAccount();
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Account successfully deleted.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    //await Future.delayed(const Duration(seconds: 5));
                    
                    await AuthService().signOut();
                    print('Successfully deleted');
                    
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  }
                },
                style: inputSmallButtonDecoration.copyWith(
                  backgroundColor: MaterialStatePropertyAll(greenColor)
                ),
                child: Text(
                  'Delete',
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
