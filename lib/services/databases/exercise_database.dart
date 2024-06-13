import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mhs_application/models/exercise.dart';
import 'dart:convert';

class ExerciseDatabaseService { 

  final FirebaseStorage _storageReference = FirebaseStorage.instance;

// Correct code but make it comment
Future<List<Exercise>> readExerciseData() async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('exercises');
  List<Exercise> exerciseList = [];

  try {
    // Fetch data once instead of using stream
    final event = await ref.once();

    if (event.snapshot.value != null) {
      List<Object?> allData = event.snapshot.value as List<Object?>;
      List<dynamic> data = json.decode(json.encode(allData));

      // Iterate over the snapshot data
      for (var data in data) {
        if (data is Map<String, dynamic>) {
          Exercise exercise = Exercise.fromJson(data);
          List<String> imagePaths = exercise.images ?? [];
          List<String> imageURLs = [];
/*
          // Fetch image URLs
          for (String imagePath in imagePaths) {
            String? imageURL = await getImageURL(imagePath);
            if (imageURL != null) {
              print(imageURL);
              imageURLs.add(imageURL);
            }
          }*/

          if (imagePaths.isNotEmpty) {
            // Get the image URL at index 0
            String imagePath = imagePaths[0]; // Fetch only the image at index 0
            String? imageURL = await getImageURL(imagePath);

            // Add the imageURL to the list if it's not null
            if (imageURL != null) {
              imageURLs.add(imageURL);
            }
          }

          // Limit the number of images to 10
          List<String> selectedImageURLs = imageURLs.take(10).toList();

          Exercise exerciseWithSelectedImages = Exercise.fromJson(data);
          exerciseWithSelectedImages.images = selectedImageURLs;
          exerciseList.add(exerciseWithSelectedImages);
        }
      }
    }
  } catch (e) {
    print(e);
  }
  return exerciseList;
}

  
/*
  Future<List<Exercise>> readExerciseData() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('exercises');
    List<Exercise> exerciseList = [];

    try {
      // Fetch data once instead of using stream
      final event = await ref.once();

      if (event.snapshot.value != null) {
        List<Object?> allData = event.snapshot.value as List<Object?>;
        List<dynamic> data = json.decode(json.encode(allData));

        // Iterate over the snapshot data
        for (var data in data) {
          if (data is Map<String, dynamic>) {
            //print('All data $data');
            Exercise exercise = Exercise.fromJson(data);
            List<String> imagePaths = exercise.images ?? [];
            //print('ww $imagePaths');
            List<String> imageURLs = [];
            for (String imagePath in imagePaths) {
              String? imageURL = await getImageURL(imagePath);
              //print('URL1 $imageURL');
              // Only add to the list if imageURL is not null
              if (imageURL != null) {
                //badge.badgeImagePath = imageURL;
                imageURLs.add(imageURL);
              }
            }
            Exercise exercise1 = Exercise.fromJson(data);
            exercise1.images = imageURLs;
            exerciseList.add(exercise1);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    print('check $exerciseList');
    return exerciseList;
  }*/
/*
  Future<List<Exercise>> readExerciseData() async {

    final DatabaseReference exerciseReference = FirebaseDatabase.instance.ref('exercises/');
    List<Exercise> exerciseList = [];
    StreamController<List<Exercise>> controller = StreamController();

    exerciseReference.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        
        Map<Object?, Object?> rawData = child.value as Map<Object?, Object?>;

        // Convert to a JSON string and then parse it as Map<String, dynamic>
        Map<String, dynamic> data = json.decode(json.encode(rawData));
        print('All data $data');
            Exercise exercise = Exercise.fromJson(data);
            List<String> imagePaths = exercise.images ?? [];
            print('ww $imagePaths');
            List<String> imageURLs = [];
            for (String imagePath in imagePaths) {
              String? imageURL = await getImageURL(imagePath);
              print('URL1 $imageURL');
              // Only add to the list if imageURL is not null
              if (imageURL != null) {
                //badge.badgeImagePath = imageURL;
                imageURLs.add(imageURL);
              }
            }
            Exercise exercise1 = Exercise.fromJson(data);
            exercise1.images = imageURLs;
            exerciseList.add(exercise1);
            controller.add(exerciseList);
        /*if (child.value != null) {
          List<Object?> allData = child.value as List<Object?>;
          List<dynamic> data = json.decode(json.encode(allData));*/

        // Iterate over the snapshot data

      }
        controller.add(exerciseList);
    }, 
    onError: (error) {
      controller.addError(error);
    });
    return controller.stream.first;
  }*/
/*
  Future<List<Exercise>> readExerciseData() async {
  final DatabaseReference exerciseReference = FirebaseDatabase.instance.ref('exercises/');
  List<Exercise> exerciseList = [];
  StreamController<List<Exercise>> controller = StreamController();

  exerciseReference.onValue.listen((event) async {
    for (final child in event.snapshot.children) {
      Map<Object?, Object?> rawData = child.value as Map<Object?, Object?>;

      // Convert to a JSON string and then parse it as Map<String, dynamic>
      Map<String, dynamic> data = json.decode(json.encode(rawData));

      Exercise exercise = Exercise.fromJson(data);
      exerciseList.add(exercise);
    }
    controller.add(exerciseList);
  }, onError: (error) {
    controller.addError(error);
  });

  return controller.stream.first;
}*/

  Future<Exercise> fetchRunningWalking(String programName) async {
    List<Exercise> exercise =
        await ExerciseDatabaseService().readExerciseData();

    Exercise selectedExercise =
        exercise.firstWhere((exercise) => exercise.name == programName);

    return selectedExercise;
  }

  Future<String?> getImageURL(String imagePath) async {
    try {
      Reference storageRef = _storageReference.ref().child(imagePath);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }
}