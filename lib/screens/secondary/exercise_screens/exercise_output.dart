import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/screens/primary/bottom_navigation_bar.dart';
import 'package:mhs_application/shared/constant.dart';

class ExerciseOutput extends StatefulWidget {
  final String programName;
  final List<int> finalReps;
  final Exercise selectedExercise;
  final String exerciseName;
  final double timeSpent;
  final int caloriesBurned;
  final int set;
  final int rep;
  final String image;

  const ExerciseOutput({
    super.key,
    required this.finalReps,
    required this.programName,
    required this.selectedExercise,
    required this.exerciseName,
    required this.timeSpent,
    required this.caloriesBurned,
    this.set = 0,
    this.rep = 0,
    required this.image,
  });

  @override
  State<ExerciseOutput> createState() => _ExerciseOutputState();
}

class _ExerciseOutputState extends State<ExerciseOutput> {
  @override
  Widget build(BuildContext context) {
    var exerciseName = widget.exerciseName;
    var set = widget.set;
    var rep = widget.rep;
    var time = widget.timeSpent;
    
    int convertSet = set.toInt();
    String exerciseSet = convertSet.toString();
    double convert = time.toDouble();
    String timeSpent = convert.toString();

    if (widget.selectedExercise.level!.isNotEmpty) {
      widget.selectedExercise.level = widget.selectedExercise.level![0].toUpperCase() +
          widget.selectedExercise.level!.substring(1).toLowerCase();
    }

    if (widget.selectedExercise.equipment!.isNotEmpty) {
      widget.selectedExercise.equipment = widget.selectedExercise.equipment![0].toUpperCase() +
          widget.selectedExercise.equipment!.substring(1).toLowerCase();
    }
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 180,
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
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
                      fontSize: 18,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.motion_photos_on_outlined,
                                color: greenColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.selectedExercise.level!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              widget.selectedExercise.equipment == 'Body only'
                                  ? Icon(
                                      Icons.accessibility_rounded,
                                      color: greenColor,
                                    )
                                  : Icon(
                                      Icons.fitness_center_rounded,
                                      color: greenColor,
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.selectedExercise.equipment!,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 130,
                        width: 170,
                        decoration: BoxDecoration(
                          color: grey100Color,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timelapse_rounded,
                                    color: greenColor,
                                    size: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Total Time',
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    timeSpent,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mins',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Spent',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 170,
                        decoration: BoxDecoration(
                          color: grey100Color,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite_rounded,
                                    color: greenColor,
                                    size: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Total Calories',
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    (widget.caloriesBurned).toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Calories',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Burned',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Builder(
                    builder: (context) {
                      if (set != 0 && rep != 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 130,
                              width: 170,
                              decoration: BoxDecoration(
                                color: grey100Color,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.numbers_rounded,
                                          color: greenColor,
                                          size: 22,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Total Sets',
                                          style: TextStyle(
                                            color: blackColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          exerciseSet,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Set',
                                              style: TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Completed',
                                              style: TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 130,
                              width: 170,
                              decoration: BoxDecoration(
                                color: grey100Color,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.numbers_rounded,
                                          color: greenColor,
                                          size: 22,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Total Reps',
                                          style: TextStyle(
                                            color: blackColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          widget.finalReps.reduce((a, b) => a + b).toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rep',
                                              style: TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Completed',
                                              style: TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox(
                          height: 0,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationBarShared(),
                        ),
                      );
                    },
                    style: inputLargeButtonDecoration.copyWith(
                      backgroundColor: MaterialStatePropertyAll(greenColor),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
