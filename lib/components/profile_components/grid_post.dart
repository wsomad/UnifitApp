import 'package:flutter/material.dart';
import 'package:mhs_application/shared/constant.dart';

class GridProfilePost extends StatefulWidget {
  const GridProfilePost({super.key});

  @override
  State<GridProfilePost> createState() => _GridProfilePostState();
}

class _GridProfilePostState extends State<GridProfilePost> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 50,
            width: 50,
            color: greenColor,
            child: Center(child: Text('Post ${index+1}')),
          ),
        );
      },
    );
  }
}