import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhs_application/components/profile_components/grid_badge.dart';
import 'package:mhs_application/components/profile_components/grid_post.dart';
import 'package:mhs_application/components/profile_components/profile_bottom_sheet.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/image_database.dart';
import 'package:mhs_application/services/student_database.dart';
import 'package:mhs_application/shared/constant.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  
  File? _image;

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    
    try {
      final student = Provider.of<Student?>(context, listen: false);
      final userId = student?.uid ?? '';
      
      // Ensure _image is not null before uploading
      if (_image != null) {
        final imageUrl = await ImageDatabaseService().uploadProfilePicture(userId, _image!);
        
        // Check if imageUrl is null, if so, provide a default value or handle gracefully
        imageUrl != null
            ? await ImageDatabaseService().updateUserProfilePicture(userId, imageUrl)
            : print('Image URL is null');
      } else {
        print('No image chosen');
      }
    } catch (e) {
      print('Error storing profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<Student?>(context);

    return DefaultTabController(
      length: 2,
      child: StreamBuilder<Student>(
        stream: StudentDatabaseService(uid: student?.uid)
            .readCurrentStudentData('${student?.uid}', 'personal'),
        builder: ((context, snapshot) {
          final data = snapshot.data;

          var username = data?.username ?? 'null';
          var faculty = data?.faculty ?? 'null';
          //var studentWeight = data?.weight;
          //num weight = studentWeight ?? 0.0;
          //var studentHeight = data?.height;
          //num height = studentHeight ?? 0.0;
          //var studentHeightMeter = height / 100;
          // heightMeter = studentHeightMeter;
          var profile = data?.profile;
          print('Gambar $profile');
          //var total = data?.countTotalExercise;

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
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showBottomSheet();
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      color: greenColor,
                                      size: 26,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _image != null
                                ? CachedNetworkImageProvider(profile!)
                                : const AssetImage('assets/images/Profile.png') as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                            Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Posts',
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Column(
                              children: [
                                Text(
                                  '10',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Workout',
                                  style: TextStyle(fontSize: 13),
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
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
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
                        icon: Icon(
                          Icons.grid_on_rounded,
                          size: 22,
                          //color: greenColor,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.star_rounded,
                          size: 26,
                          //color: greyColor,
                        ),
                      )
                    ],
                    indicatorColor: greenColor,
                    labelColor: greenColor,
                    unselectedLabelColor: greyColor,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const TabBarView(
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
