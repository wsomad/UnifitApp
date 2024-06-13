import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  var day = DateTime.now().weekday;
  var currentWeek = ExerciseExecution().getCurrentWeek();

  String _truncateName(String name) {
    if (name.length > 1) {
      return name[0] + name[1] + '*' * (name.length - 1);
    } else {
      return name;
    }
  }

  Widget _buildAvatar(int index) {
    Color placingColor;
    switch (index) {
      case 0:
        placingColor = goldColor;
        break;
      case 1:
        placingColor = silverColor;
        break;
      case 2:
        placingColor = bronzeColor;
        break;
      default:
        placingColor = greenColor;
    }
    return CircleAvatar(
      maxRadius: 12,
      backgroundColor: placingColor,
      child: Text(
        '${index + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildText(int index) {
    return Text(
      '${index + 1}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student>(context);

    return StreamBuilder<List<Student>>(
        stream: StudentDatabaseService().readAllStudentsRank('students'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          List<Student> students = snapshot.data ?? [];

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Sort the students based on total calories burned
          students.sort((a, b) => (b.countTotalCalories ?? 0).compareTo(a.countTotalCalories ?? 0));

          return Scaffold(
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: greenColor,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(60, 20, 0, 0),
                              child: Text(
                                'Leaderboard',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Container(
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: grey100Color,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Week $currentWeek',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: greenColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                                color: greenColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '          ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: whiteColor),
                                      ),
                                      Text(
                                        'Username',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: whiteColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              height: 60,
                              color: greenColor,
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Faculty',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: whiteColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                color: greenColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Calories',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: whiteColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];

                            Widget avatarWidget = index < 3
                                ? _buildAvatar(index)
                                : _buildText(index);

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: grey100Color,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: grey100Color,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 0, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      avatarWidget,
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        (studentUser.uid ==
                                                                student.uid)
                                                            ? student.username =
                                                                'You'
                                                            : _truncateName(
                                                                student
                                                                    .username!),
                                                        style: (studentUser
                                                                    .uid ==
                                                                student.uid)
                                                            ? TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    greenColor,
                                                                fontSize: 16,
                                                              )
                                                            : const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 20, 0, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        student.faculty ??
                                                            'null',
                                                        style: (studentUser
                                                                    .uid ==
                                                                student.uid)
                                                            ? TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    greenColor,
                                                                fontSize: 16,
                                                              )
                                                            : const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 20, 15, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        (student.countTotalCalories ??
                                                                0)
                                                            .toString(),
                                                        style: (studentUser
                                                                    .uid ==
                                                                student.uid)
                                                            ? TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    greenColor,
                                                                fontSize: 16,
                                                              )
                                                            : const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                              ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
