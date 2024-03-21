import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  late DateTime dnow;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    dnow = DateTime.now();
    formattedDate = dnow.toString();
  }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.delete,
                          color: greenColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Notification ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(formattedDate),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
