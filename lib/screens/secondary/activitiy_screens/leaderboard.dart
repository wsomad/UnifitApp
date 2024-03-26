import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final List<String> names = ['Haikal', 'Najmi', 'Ismail'];
  final List<String> faculties = ['FSG', 'FSKM', 'FSKM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
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
                    const Text('      '),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Text('2nd Place'),
                        Container(
                          height: 140,
                          width: 100,
                          decoration: BoxDecoration(
                              color: silverColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                              )),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(fontSize: 60, color: whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('1st Place'),
                        Container(
                          height: 180,
                          width: 100,
                          decoration: BoxDecoration(
                              color: goldColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(fontSize: 60, color: whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('3rd Place'),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.brown[700],
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5))),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(fontSize: 60, color: whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2,
                        color: greenColor
                      ),
                    )
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'No.',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Username | Faculty',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Calories Burned',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: names.length,
            itemBuilder: (context, index) {
              var name = names[index];
              var faculty = faculties[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: greenColor,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                  color: whiteColor, fontWeight: FontWeight.bold),
                            ), // You can put any text or icon here
                          ),
                          Text(
                            '$name | $faculty',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ), // Ac
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
