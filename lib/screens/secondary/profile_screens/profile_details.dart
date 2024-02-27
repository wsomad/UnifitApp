import 'package:flutter/material.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {

  final List<Widget> tabs = [
    Tab(
      icon: Icon(
        Icons.collections_bookmark_rounded,
        color: greyColor,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.star_outline_rounded,
        color: greyColor,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<Student>(context);

    return StreamBuilder<Student>(
      stream: StudentDatabaseService(uid: student.uid)
          .readCurrentStudentData('students/${student.uid}/personal'),
      builder: ((context, snapshot) {
        final data = snapshot.data;

        var username = data?.username ?? 'null';
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
                            Icon(
                              Icons.notifications_none_rounded,
                              color: greenColor,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.menu,
                              color: greenColor,
                              size: 28,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          image,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      username,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            TabBar(tabs: tabs),
            /*GridView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: greenColor,
                    child: Center(child: Text('Post ${index+1}')),
                  ),
                );
              },
            ),*/
          ],
        );
      }),
    );
  }
}
