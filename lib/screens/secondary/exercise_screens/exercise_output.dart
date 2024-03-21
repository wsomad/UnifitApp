import 'package:flutter/material.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/shared/constant.dart';

class ExerciseOutput extends StatefulWidget {
  final String exerciseName;
  final double timeSpent;
  final int caloriesBurned;
  final int set;
  final int rep;

  ExerciseOutput({
    Key? key,
    required this.exerciseName,
    required this.timeSpent,
    required this.caloriesBurned,
    this.set = 0,
    this.rep = 0,
  }) : super(key: key);

  @override
  State<ExerciseOutput> createState() => _ExerciseOutputState();
}

class _ExerciseOutputState extends State<ExerciseOutput> {
  @override
  Widget build(BuildContext context) {
    var exerciseName = widget.exerciseName;

    var set = widget.set;
    int convertSet = set.toInt();
    String exerciseSet = convertSet.toString();

    var rep = widget.rep;
    int totalRep = rep * set;
    int convertRep = totalRep.toInt();
    String exerciseRep = convertRep.toString();

    var time = widget.timeSpent;
    double convert = time.toDouble();
    String timeSpent = convert.toString();
    var exerciseImage = 'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: greenColor,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text('      '),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 180,
                    child: Image.asset(
                      exerciseImage,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  exerciseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '20/2/2024',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Time Spent',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '$timeSpent minutes',
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Calories Burned',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '300',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Builder(
                  builder: (context) {
                    if (set != 0 && rep != 0) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total No. of Sets',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                exerciseSet,
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total No. of Reps',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                exerciseRep,
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      );
                    } 
                    else {
                      return const SizedBox(
                        height: 0,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: inputSmallButtonDecoration.copyWith(
                          backgroundColor:
                              MaterialStatePropertyAll(greenColor)),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationBarShared()),
                        );
                      },
                      style: inputSmallButtonDecoration.copyWith(
                        backgroundColor: MaterialStatePropertyAll(greenColor),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
*/
