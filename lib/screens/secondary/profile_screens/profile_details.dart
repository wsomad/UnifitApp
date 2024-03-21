import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhs_application/components/profile_components/grid_badge.dart';
import 'package:mhs_application/components/profile_components/grid_post.dart';
import 'package:mhs_application/components/profile_components/profile_bottom_sheet.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/screens/secondary/notifications.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final List<Widget> tabs = const [
    Tab(
      icon: Icon(Icons.grid_on_rounded
          //color: greenColor,
          ),
    ),
    Tab(
      icon: Icon(
        Icons.bookmark_outline_rounded,
        //color: greyColor,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<Student>(context);

    return DefaultTabController(
      length: 2,
      child: StreamBuilder<Student>(
        stream: StudentDatabaseService(uid: student.uid)
            .readCurrentStudentData('students/${student.uid}/personal'),
        builder: ((context, snapshot) {
          final data = snapshot.data;

          var username = data?.username ?? 'null';
          var faculty = data?.faculty ?? 'null';
          var studentWeight = data?.weight;
          num weight = studentWeight ?? 0.0;
          var studentHeight = data?.height;
          num height = studentHeight ?? 0.0;
          print('weight $weight');
          print('height $height');
          var studentHeightMeter = height / 100;
          num heightMeter = studentHeightMeter;

          print('meter $heightMeter');
          var studentBmi = weight / (heightMeter * heightMeter);
          num bmi = studentBmi;
          String bmiValue = bmi.toStringAsFixed(2);
          var image = 'assets/images/Profile.png';

          var total = data?.countTotalExercise;
          print('exercise $total');

          return Builder(
            builder: (context) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context,  rootNavigator: true).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const Notifications(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.notifications_none_rounded,
                                      color: greenColor,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showBottomSheet();
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      color: greenColor,
                                      size: 28,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          image,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${username} | ${faculty}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Posts',
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            const Column(
                              children: [
                                Text(
                                  '10',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rank',
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Column(
                              children: [
                                Text(
                                  bmiValue,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'BMI',
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            )
                          ],
                        ),                        
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.grid_on_rounded
                            //color: greenColor,
                            ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.stars,
                          //color: greyColor,
                        ),
                      )
                    ],
                    indicatorColor: greenColor,
                    labelColor: greenColor,
                    unselectedLabelColor: greyColor,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                  const SizedBox(
                    height: 1000,
                    child: TabBarView(
                      children: [
                        GridProfilePost(),
                        GridProfileBadge(),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          height: 280,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: const ProfileBottomSheet(),
        );
      },
    );
  }
}
