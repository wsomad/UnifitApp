import 'package:flutter/material.dart';
import 'package:mhs_application/screens/secondary/exercise_screens/program_card_vertical.dart';

class Program extends StatefulWidget {
  const Program({super.key});

  @override
  State<Program> createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  @override
  Widget build(BuildContext context) {    
    return const Scaffold(
      body: ProgramCardVertical(),
    );
  }
}
