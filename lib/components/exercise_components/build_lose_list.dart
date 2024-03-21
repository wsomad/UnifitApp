// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class BuildLoseList extends StatefulWidget {
  final int set;
  final int rep;

  const BuildLoseList({
    super.key,
    required this.set,
    required this.rep
  });

  @override
  State<BuildLoseList> createState() => _BuildLoseListState();
}

class _BuildLoseListState extends State<BuildLoseList> {
  late List<int> repsList;
  late List<bool> isSetDone;

  @override
  void initState() {
    super.initState();
    // Initialize the repsList based on the provided set and rep values
    repsList = List<int>.filled(widget.set, widget.rep);
    isSetDone = List<bool>.filled(widget.set, false);
  }

  void increaseReps(int rep) {
    setState(() {
      repsList[rep]++;
    });
  }

  void decreaseReps(int rep) {
    if (repsList[rep] > 0) {
      setState(() {
        repsList[rep]--;
      });
    }
    if (repsList[rep] == 0) {
      setState(() {
        repsList[rep] = 1;
      });
    }
  }

  void addSet() {}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: repsList.length,
      itemBuilder: (context, index) {
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set ${index + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${repsList[index]} reps',
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          decreaseReps(index);
                        },
                        child: Icon(
                          Icons.remove_circle_outline_rounded,
                          color: greenColor,
                          size: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          increaseReps(index);
                        },
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          color: greenColor,
                          size: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSetDone[index] = !isSetDone[index];
                          });
                          if (isSetDone[index]) {
                            print('Done set ${index + 1}!');
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Completed set ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              duration: const Duration(seconds: 5),
                              backgroundColor: greenColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          } else {
                            print('Undone set ${index + 1}!');
                          }
                        },
                        child: isSetDone[index] 
                          ? Icon(
                            Icons.check_circle_rounded,
                            color: greenColor,
                            size: 35,
                          )
                          : Icon(
                          Icons.check_circle_outline_rounded,
                          color: greenColor,
                          size: 35,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
