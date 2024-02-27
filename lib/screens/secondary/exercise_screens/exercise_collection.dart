// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/shared/bottom_navigation_bar.dart';
import 'package:mhs_application/components/exercise_components/exercise_card_vertical.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/shared/constant.dart';

class ExerciseCollection extends StatefulWidget {

  final String programName;
  final List<Exercise> exerciseList;

  const ExerciseCollection({
    super.key,
    required this.programName,
    required this.exerciseList,
  });

  @override
  State<ExerciseCollection> createState() => _ExerciseCollectionState();
}

class _ExerciseCollectionState extends State<ExerciseCollection> {
  final TextEditingController searchController = TextEditingController();
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.exerciseList;
  }

  @override
  void dispose() {
    print('Dispose called for ${widget.programName}');
    BottomNavigationBarShared.navigationKey.currentState
        ?.setBottomNavBarVisible(true);
    super.dispose();
  }

  void searchExercise() {
    String searchingQuery = searchController.text.toLowerCase();
    List<Exercise> filteredList = widget.exerciseList
        .where((exercise) =>
            //searchingQuery.contains(exercise.name!) ||
            //searchingQuery.contains(exercise.equipment!)
            exercise.name!.toLowerCase().contains(searchingQuery) ||
            //exercise.level!.toLowerCase().contains(searchingQuery) ||
            exercise.equipment!.toLowerCase().contains(searchingQuery)
            )
        .toList();
    
    print('Filtered List: $filteredList');

    setState(() {
      filteredExercises = filteredList;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      widget.programName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Search Exercise',
                        suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 30,
                              color: greenColor,
                            ),
                            onPressed: () {
                              searchController.clear();
                              searchExercise();
                            },
                          )
                        : Icon(
                            Icons.search,
                            size: 30,
                            color: greenColor,
                          ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15)),
                    controller: searchController,
                    onChanged: (value) {
                      searchExercise();
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ExerciseCardVertical(
                programName: widget.programName,
                exerciseList: widget.exerciseList,
                filteredExerciseList: filteredExercises,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
