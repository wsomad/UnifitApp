import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class GridProfilePost extends StatefulWidget {
  const GridProfilePost({super.key});

  @override
  State<GridProfilePost> createState() => _GridProfilePostState();
}

class _GridProfilePostState extends State<GridProfilePost> {
  var exerciseImage =
            'assets/images/Barbell_Bench_Press_-_Medium_Grip_0.jpg';
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 20,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 50,
            width: 50,
            color: greenColor,
            child: Image.asset(
              exerciseImage,
              fit: BoxFit.cover,
            )
            //Center(child: Text('Post ${index+1}')),
          ),
        );
      },
    );
  }
}