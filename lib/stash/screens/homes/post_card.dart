import 'package:flutter/material.dart';
import 'package:mhs_application/models/post.dart';
import 'package:mhs_application/services/databases/student_database.dart';
import 'package:mhs_application/shared/constant.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    var exerciseImage = 'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
    var image = 'assets/images/Profile.png';

    return StreamBuilder<List<Post>>(
        stream: StudentDatabaseService().readAllStudentsPost('posts'),
        builder: (context, snapshot) {
          List<Post> data = snapshot.data ?? [];

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final postData = data[index];
              var username = postData.username;
              var faculty = postData.faculty;
              var age = postData.age;

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
                              height: 200,
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
                                  radius: 16,
                                  backgroundImage: AssetImage(image),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '$username | $age',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.favorite_border_rounded,
                                color: greenColor,
                              ),
                              const Text(
                                '20 Dec 2023',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$username',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
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
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
