// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mhs_application/services/exercise_database.dart';
import 'package:mhs_application/screens/primary/bottom_navigation_bar.dart';
import 'package:mhs_application/components/exercise_components/exercise_card_vertical.dart';
import 'package:mhs_application/models/exercise.dart';
import 'package:mhs_application/shared/constant.dart';

class ExerciseCollection extends StatefulWidget {
  final String programName;
  final List<Exercise> exerciseList;
  final int sets;
  final int reps;
  final String type;

  const ExerciseCollection({
    super.key,
    required this.programName,
    required this.exerciseList,
    required this.sets,
    required this.reps,
    required this.type,
  });

  @override
  State<ExerciseCollection> createState() => _ExerciseCollectionState();
}

class _ExerciseCollectionState extends State<ExerciseCollection> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<Exercise>> fetchExercise;
  List<Exercise> exerciseList = [];
  List<Exercise> filteredExercises = [];
  bool shouldFetchExercises = false; 

  @override
  void initState() {
    super.initState();
    fetchExercise = ExerciseDatabaseService().readExerciseData();
    fetchExercise.then((exercises) {
      setState(() {
        exerciseList = exercises;
        filteredExercises = exercises;
      });
    });
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
    List<Exercise> filteredList = exerciseList
        .where((exercise) =>
            exercise.name!.toLowerCase().contains(searchingQuery) ||
            exercise.equipment!.toLowerCase().contains(searchingQuery) ||
            exercise.primaryMuscles!.any((element) => element.toLowerCase().contains(searchingQuery)) ||
            exercise.secondaryMuscles!.any((element) => element.toLowerCase().contains(searchingQuery))
            )
        .toList();

    setState(() {
      filteredExercises = filteredList;
    });
  }

  void onSearchInitiated() {
    setState(() {
      shouldFetchExercises = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Exercise>>(
        future: fetchExercise,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No exercises found.');
          } else {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: greenColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text(
                          widget.programName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text('       '),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                          controller: searchController,
                          onChanged: (value) {
                            searchExercise();
                            if (!shouldFetchExercises) {
                              onSearchInitiated();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ExerciseCardVertical(
                  programName: widget.programName,
                  exerciseList: exerciseList,
                  filteredExerciseList: filteredExercises,
                  sets: widget.sets,
                  reps: widget.reps,
                  type: widget.type,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
