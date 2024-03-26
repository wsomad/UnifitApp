import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhs_application/screens/secondary/profile_screens/edit_profile.dart';
import 'package:mhs_application/shared/constant.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) =>
                  const EditProfile()
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: greenColor,
                  size: 28,
                ),
                const SizedBox(width: 20,),
                const Text(
                  'Email & Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) =>
                  const EditProfile()
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit_rounded,
                  color: greenColor,
                  size: 28,
                ),
                const SizedBox(width: 20,),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Icon(
                Icons.delete_rounded,
                color: greenColor,
                size: 28,
              ),
              const SizedBox(width: 20,),
              const Text(
                'Delete Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: greenColor,
                size: 28,
              ),
              const SizedBox(width: 20,),
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
