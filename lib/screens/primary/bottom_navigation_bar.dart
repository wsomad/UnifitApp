// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mhs_application/screens/primary/activity.dart';
import 'package:mhs_application/screens/primary/program.dart';
import 'package:mhs_application/screens/primary/home.dart';
import 'package:mhs_application/screens/primary/profile.dart';
import 'package:mhs_application/shared/constant.dart';

class BottomNavigationBarShared extends StatefulWidget {
  const BottomNavigationBarShared({super.key});

  static GlobalKey<_BottomNavigationBarSharedState> navigationKey =
      GlobalKey<_BottomNavigationBarSharedState>();

  @override
  State<BottomNavigationBarShared> createState() =>
      _BottomNavigationBarSharedState();
}

class _BottomNavigationBarSharedState extends State<BottomNavigationBarShared> {
  int _currentIndex = 0;
  bool _bottomNavBarVisible = true;

  final List<String> _routeNames = [
    //'/home',
    '/program',
    '/activity',
    //'/profile'
  ];

  final List<String> screenname = [
    //'Home',
    'Exercise',
    'Activity',
    //'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => _buildScreen(context, _routeNames[_currentIndex]),
            );
          },
        ),
        bottomNavigationBar: _bottomNavBarVisible
        ? Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                spreadRadius: 1, 
                blurRadius: 40, 
                offset: Offset(0, 50), 
              ),
            ],
            color: whiteColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: GNav(
              tabs: [/*
                GButton(
                  icon: Icons.home_filled,
                  text: 'Home',
                  textSize: 14,
                  backgroundColor: greenColor,
                  iconColor: Colors.grey,
                ),*/
                GButton(
                  icon: Icons.fitness_center_rounded,
                  text: 'Program',
                  textSize: 14,
                  backgroundColor: greenColor,
                  iconColor: Colors.grey,
                ),
                GButton(
                  icon: Icons.stacked_line_chart_rounded,
                  text: 'Activity',
                  textSize: 14,
                  backgroundColor: greenColor,
                  iconColor: Colors.grey,
                ),/*
                GButton(
                  icon: Icons.account_circle_sharp,
                  text: 'Profile',
                  textSize: 14,
                  backgroundColor: greenColor,
                  iconColor: Colors.grey,
                ),*/
              ],
              iconSize: 24,
              backgroundColor: whiteColor,
              color: whiteColor,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.black,
              padding: const EdgeInsets.all(10),
              gap: 10,
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                  var screenIndex = screenname[_currentIndex];
                  print('User select $screenIndex screen');
                });
              },
            ),
          ),
        )
        : null,
      ),
    );
  }

  void setBottomNavBarVisible(bool visible) {
    setState(() {
      _bottomNavBarVisible = visible;
    });
  }

  Widget _buildScreen(BuildContext context, String routeName) {
    switch (routeName) {
      /*case '/home':
        return const Home();*/
      case '/program':
        return const Program();
      case '/activity':
        return const Activity();
      /*case '/profile':
        return const Profile();*/
      default:
        return const Program();
    }
  }
}
