import 'package:flutter/material.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class WeeklyProgression extends StatefulWidget {
  const WeeklyProgression({super.key});

  @override
  State<WeeklyProgression> createState() => _WeeklyProgressionState();
}

class _WeeklyProgressionState extends State<WeeklyProgression> {
  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student>(context);
    var currentWeek = ExerciseExecution().getCurrentWeek();

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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          'Progression',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Text('      '),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(color: greenColor, width: 2),
                        )),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'BMI History',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<MapEntry<String, dynamic>>>(
                      stream: StudentDatabaseService()
                          .displayBMI('${studentUser.uid}'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No data available'));
                        } else {
                          final weekBmis = snapshot.data!;

                          weekBmis.sort((a, b) {
                            // Extract and parse week numbers as integers
                            int weekA = int.tryParse(a.key.split(' ')[1]) ?? 0;
                            int weekB = int.tryParse(b.key.split(' ')[1]) ?? 0;

                            // Sort by week number in descending order
                            return weekB.compareTo(weekA);
                          });

                          // Get the current week
                          var currentWeek =
                              ExerciseExecution().getCurrentWeek();

                          // Filter the list to show only weeks up to the current week
                          final filteredWeekBmis = weekBmis.where((entry) {
                            int week =
                                int.tryParse(entry.key.split(' ')[1]) ?? 0;
                            return week <= currentWeek;
                          }).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredWeekBmis.length,
                            itemBuilder: (context, index) {
                              final weekString = filteredWeekBmis[index].key;
                              final weekNumber =
                                  int.tryParse(weekString.split(' ')[1]) ?? 0;
                              final value = filteredWeekBmis[index].value;
                              final displayValue = value is double
                                  ? value.toStringAsFixed(2)
                                  : value.toString();

                              double? previousValue;
                              if (index < filteredWeekBmis.length - 1) {
                                final prevValue = filteredWeekBmis[index + 1].value;
                                previousValue = prevValue is double ? prevValue : null;
                              }

                              double? bmiDifference;
                              if (value is double && previousValue != null) {
                                bmiDifference = value - previousValue;
                              }

                              print(bmiDifference);

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      
                                      color: weekNumber == currentWeek
                                          ? greenColor
                                          : grey100Color,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          weekNumber == currentWeek
                                              ? 'Current Week'
                                              : '${weekString[0].toUpperCase()}${weekString.substring(1)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: weekNumber == currentWeek
                                                ? whiteColor
                                                : blackColor,
                                          ),
                                        ),
                                        Column(
                                          children: [                                        
                                            Text(
                                              displayValue,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: weekNumber == currentWeek
                                                    ? FontWeight.bold
                                                    : FontWeight.bold,
                                                color: weekNumber == currentWeek
                                                    ? whiteColor
                                                    : blackColor,
                                              ),
                                            ),  
                                            const SizedBox(height: 5,),
                                            if (bmiDifference != null)
                                              Text(
                                                bmiDifference.toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: bmiDifference < 0 ? Colors.blue : Colors.red,
                                                ),
                                              ),                                      
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
