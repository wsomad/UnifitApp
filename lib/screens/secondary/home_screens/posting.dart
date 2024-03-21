import 'package:flutter/material.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/shared/constant.dart';

class Posting extends StatefulWidget {
  const Posting({super.key});

  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  var image = 'assets/images/Profile.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          'New Post',
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
                  height: 20,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(image),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Muhammad Haikal',
                      style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: greyColor, // Choose your border color
                        width: 2, // Choose the border width
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        print('oh yeahh');
                      },
                      child: Text(
                        'Import image from gallery',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blackColor
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Share your routine...',
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15),
                  onChanged: (text) {
                    // Handle the text change
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {

                  },
                  style: inputLargeButtonDecoration.copyWith(
                    backgroundColor: MaterialStatePropertyAll(greenColor)
                  ),
                  child: Text(
                    'Post to Community',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: whiteColor
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
