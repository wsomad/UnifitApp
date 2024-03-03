import 'package:flutter/material.dart';

class GridProfileBadge extends StatefulWidget {
  const GridProfileBadge({super.key});

  @override
  State<GridProfileBadge> createState() => _GridProfileBadgeState();
}

class _GridProfileBadgeState extends State<GridProfileBadge> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (BuildContext context, index) {
        String image = "assets/images/15_minutes_workout.png";
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            child: Image.asset(
              image,
            )
            //Center(child: Text('${index + 1}')),
          ),
        );
      },
    );
  }
}
