import 'package:flutter/material.dart';
import 'package:mhs_application/models/badges.dart';
import 'package:mhs_application/models/exercise_execution.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/databases/badge_database.dart';
import 'package:mhs_application/services/databases/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class BadgesCollection extends StatefulWidget {
  const BadgesCollection({super.key});

  @override
  State<BadgesCollection> createState() => _BadgesCollectionState();
}

class _BadgesCollectionState extends State<BadgesCollection> {
  var currentWeek = ExerciseExecution().getCurrentWeek();

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<Student>(context);

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
                          'Badges',
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
                  height: 40,
                ),
                // Section for Calories Burned Badges
                _buildBadgeSection(
                  context,
                  'Calories Burned',
                  'badges/calories',
                  studentUser,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeSection(BuildContext context, String title, String path, Student studentUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
            left: BorderSide(color: greenColor, width: 2),
          )),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Badges?>>(
          future: BadgeDatabaseService().readBadgeDetails(path),
          builder: (context, badgeSnapshot) {
            if (badgeSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (badgeSnapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else if (!badgeSnapshot.hasData || badgeSnapshot.data!.isEmpty) {
              return const Center(child: Text('No badges available'));
            } else {
              // Pastikan data badges sentiasa ada
              final badges = badgeSnapshot.data!;
              badges.sort((a, b) => int.parse(a!.category!).compareTo(int.parse(b!.category!)));

              return StreamBuilder<Student>(
                stream: StudentDatabaseService().readStudentBadges('${studentUser.uid}', 'badge/week $currentWeek/badge'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else {
                    final Set<String?> obtainedBadgeIds = snapshot.hasData && snapshot.data != null
                        ? snapshot.data!.badge?.map((badge) => badge.badgeID).toSet() ?? {}
                        : {};
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: badges.length,
                      itemBuilder: (BuildContext context, index) {
                        Badges? badge = badges[index];
                        final badgeName = badge?.badgeName ?? 'No data';
                        final badgeImage = badge?.badgeImagePath;
                        bool isObtained = obtainedBadgeIds.contains(badge?.badgeID);

                        return SizedBox(
                          height: 620,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    badgeImage!,
                                    height: 80,
                                    width: 80,
                                  ),
                                  if (!isObtained)
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white.withOpacity(1),
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  color: grey100Color,
                                ),
                                child: Text(
                                  badgeName,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: greenColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }
}
