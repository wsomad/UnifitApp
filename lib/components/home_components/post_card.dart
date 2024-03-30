import 'package:flutter/material.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/user_database.dart';
import 'package:mhs_application/shared/constant.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  List<String> username = [
    'John Doe',
    'Johnny Depp',
    'Zul Ariffin',
    'Tom Spider',
    'Remy Ishak'
  ];
  List<String> facultyName = [
    'FSG',
    'FSKM',
    'FSKM',
    'FP',
    'FSG',
  ];

  @override
  Widget build(BuildContext context) {
    var exerciseImage = 'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
    var image = 'assets/images/Profile.png';

    return StreamBuilder<List<Student>>(
      stream: StudentDatabaseService().readAllStudents('students'),
      builder: (context, snapshot) {
        List<Student>? studentData = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: studentData?.length,
          itemBuilder: (context, index) {
            final data = studentData?[index];

            var username = data?.username;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: SizedBox(
                            height: 220,
                            child: Image.asset(
                              exerciseImage,
                              width: 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(image),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '$username | ss',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.favorite_border_rounded,
                              color: greenColor,
                            ),
                            const Text('20 Dec 2023'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'test',
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse a ante nec risus facilisis malesuada.'
                            ' Quisque sollicitudin, ipsum convallis sollicitudin lacinia, ex massa sodales ante, id pretium quam risus sit amet ante.'
                            'Nulla bibendum porta nunc, vel mollis est pellentesque nec. Sed gravida ante nec nisl cursus iaculis.',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
