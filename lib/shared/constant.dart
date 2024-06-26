import 'package:flutter/material.dart';

// Color code
Color greenColor = const Color(0xFF66CC66);
Color whiteColor = const Color(0xFFFFFFFF);
Color grey100Color = const Color(0XFFF5F5F5);
Color greyColor = const Color(0xFFE0E0E0);
Color goldColor = const Color(0xFFF0D77A);
Color silverColor = const Color(0XFFC0BFBF);
Color bronzeColor = const Color(0XFF835C34);
Color blackColor = const Color(0xFF000000);
Color beginnerColor = const Color(0xFF0D47A1);
Color intermediateColor = const Color(0XFFC62828);
Color expertColor = const Color(0XDD010000);

// TexFormField
var textInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(
      color: grey100Color,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: greenColor,
        width: 2,
      )),
);

// Small TextFormField
var smallTextInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: greyColor,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: greenColor,
        width: 2,
      )),
);

// Dropdown
var dropDownDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: greyColor,
      width: 2,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: greyColor,
      width: 2,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

// ElevatedButton #1
var inputLargeButtonDecoration = ButtonStyle(
  fixedSize: MaterialStateProperty.all(
    const Size(400, 50),
  ),
  backgroundColor: MaterialStateProperty.all(greenColor),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
);

// ElevatedButton #2
var inputSmallButtonDecoration = ButtonStyle(
  fixedSize: MaterialStateProperty.all(
    const Size(170, 50),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

// ElevatedButton #3
var inputTinyButtonDecoration = ButtonStyle(
  padding: const MaterialStatePropertyAll(EdgeInsets.all(1.0)),
  minimumSize: const MaterialStatePropertyAll(Size(70, 4)),
  backgroundColor: MaterialStateProperty.all(greenColor),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color: greenColor,
        width: 2,
      ),
    ),
  ),
);
