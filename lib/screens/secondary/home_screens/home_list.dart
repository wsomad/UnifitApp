import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhs_application/components/home_components/post_card.dart';
import 'package:mhs_application/screens/secondary/home_screens/posting.dart';
import 'package:mhs_application/screens/secondary/notifications.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/shared/constant.dart';

class HomeList extends StatefulWidget {
  const HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Home',
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
                            const Posting(),
                          ),
                        );
                        print('User click create new post button');
                      },
                      child: Icon(
                        Icons.add,
                        color: greenColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('User click view activity button');
                      },
                      child: Icon(
                        Icons.show_chart_rounded,
                        color: greenColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context,  rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) =>
                            const Notifications(),
                          ),
                        );
                        print('User click view notification button');
                      },
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: greenColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        const PostCard(),
      ],
    );
  }
}