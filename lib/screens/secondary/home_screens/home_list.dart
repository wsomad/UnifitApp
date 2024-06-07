// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/components/home_components/post_card.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/screens/secondary/home_screens/posting.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:mhs_application/shared/custom_bmi_dialog.dart';

class HomeList extends StatefulWidget {
  const HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForNewWeek();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkForNewWeek() async {
    var day = DateTime.now().weekday;
    int currentWeek = ExerciseExecution().getCurrentWeek();
    int previousWeek = ExerciseExecution().getPreviousWeek();

    if (currentWeek != previousWeek) {
      if (day == 1) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomInputDialog(
                title: 'Requirement',
                message: 'By updating your weight every week, we can determine your latest BMI and ideal BMI for you to achieved.',
              );
            },
          );
        }
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => const Posting(),
                          ),
                        );
                        print('User click create new post button');
                      },
                      child: Icon(
                        Icons.add,
                        color: greenColor,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const PostCard(),
      ],
    );
  }
}
