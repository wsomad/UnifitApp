import 'package:flutter/material.dart';
import 'package:mhs_application/models/badges.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/services/student_database.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';

class GridProfileBadge extends StatefulWidget {
  const GridProfileBadge({super.key});

  @override
  State<GridProfileBadge> createState() => _GridProfileBadgeState();
}

class _GridProfileBadgeState extends State<GridProfileBadge> {

  var currentWeek = ExerciseExecution().getCurrentWeek();
  
  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student>(context);
    
    return StreamBuilder<Student>(
      stream: StudentDatabaseService().readStudentBadges('${studentUser.uid}', 'badge/week $currentWeek/badge'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading, return a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If there's an error with the stream, handle it here
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          // If no data is available, return an empty widget
          return Center(child: Text('No data available'));
        } else {
          // Access the Student object from the snapshot
          final studentData = snapshot.data!;
          print('Check $studentData');

          // Iterate over the badges and display them using GridView.builder
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: studentData.badge?.length,
            itemBuilder: (BuildContext context, index) {
              // Access the badge at the current index
              Badges badge = studentData.badge![index];
              print('Badge name: ${badge.badgeName}');

              print('Length: ${studentData.badge?.length}');

              // Use badge properties to display badge information
              return studentData.badge!.isEmpty 
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Column(
                      children: [
                        Image.network(
                          badge.badgeImagePath!,
                          height: 80,
                          width: 80,
                        ),
                        Text(badge.badgeName!),
                      ],
                    ),
                  ),
                );
            },
          );
        }
      }
    );
  }
}
