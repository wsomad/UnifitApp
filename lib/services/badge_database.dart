// ignore_for_file: await_only_futures

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mhs_application/models/badges.dart';
import 'package:mhs_application/models/exercise_execution.dart';

class BadgeDatabaseService {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storageReference = FirebaseStorage.instance;
  var day = DateTime.now().weekday;
  var week = ExerciseExecution().getCurrentWeek();

  Future<List<Badges>> readBadgeDetails(String sourcePath) async {
    final ref = _databaseReference.child(sourcePath);
    List<Badges> badgesList = [];

    try {
      // Fetch data once instead of using stream
      final event = await ref.once();

      if (event.snapshot.value != null) {
        Map<Object?, Object?> rawData = event.snapshot.value as Map<Object?, Object?>;
        Map<String, dynamic> data = json.decode(json.encode(rawData));
        // Iterate over the snapshot data
        for (var entry in data.entries) {
          var value = entry.value;
          if (value != null) {
            Map<String, dynamic> data = value as Map<String, dynamic>;
            Badges badge = Badges.fromJson(data);
            String imagePath = badge.badgeImagePath ?? 'null';
            String? imageURL = await getImageURL(imagePath);
            print('Badge URL $imageURL');
            // Only add to the list if imageURL is not null
            if (imageURL != null) {
              badge.badgeImagePath = imageURL;
              badgesList.add(badge);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return badgesList;
  }

  Future<void> storeBadges(List<Badges> awardedBadges, String userID) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('students/$userID/badge/week $week/badge');
    try {
      for (var badge in awardedBadges) {
      await ref.child(badge.badgeID!).set({
        'badgeID': badge.badgeID,
        'badgeName': badge.badgeName,
        'badgeType': badge.badgeType,
        'badgeImagePath': badge.badgeImagePath,
      });
    }
    print('Badges stored successfully for user $userID');
      print('write');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isBadgeAwardedToUser(String badgeID, String userID) async {
  try {
    // Reference to the badge for the user in the database
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('students/$userID/badge/week $week/badge/$badgeID');

    // Fetch data once instead of using stream
    final event = await ref.once();

    // Check if the badge exists for the user
    return event.snapshot.exists;
  } catch (e) {
    print('Error checking badge: $e');
    return false;
  }
}

  Future<String?> getImageURL(String imagePath) async {
    try {
      ///String storagePath = imagePath.replaceFirst('gs://mhs-application.appspot.com/', '');
      Reference storageRef = _storageReference.ref().child(imagePath);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }

  // Muscle building and weight loss
  List<Badges> checkMBWLQualification(double totalTime, List<Badges> badgesList) {
    List<Badges> achievementBadges = [];

    for (var badge in badgesList) {
      if (totalTime >= 0 && totalTime < 50) {
        achievementBadges.add(
          Badges(
            badgeID: badge.badgeID,
            badgeImagePath: badge.badgeImagePath,
            badgeName: badge.badgeName,
            badgeType: badge.badgeType,
          )
        );
      }
      else if (totalTime >= 50 && totalTime < 100) {
        achievementBadges.add(
          Badges(
            badgeID: badge.badgeID,
            badgeImagePath: badge.badgeImagePath,
            badgeName: badge.badgeName,
            badgeType: badge.badgeType,
          )
        );
      }
      else if (totalTime >= 100 && totalTime < 500) {
        achievementBadges.add(
          Badges(
            badgeID: badge.badgeID,
            badgeImagePath: badge.badgeImagePath,
            badgeName: badge.badgeName,
            badgeType: badge.badgeType,
          )
        );
      }
      else if (totalTime >= 500 && totalTime < 1000) {
        achievementBadges.add(
          Badges(
            badgeID: badge.badgeID,
            badgeImagePath: badge.badgeImagePath,
            badgeName: badge.badgeName,
            badgeType: badge.badgeType,
          )
        );
      }
      else if (totalTime >= 1000 && totalTime < 3000) {
        achievementBadges.add(
          Badges(
            badgeID: badge.badgeID,
            badgeImagePath: badge.badgeImagePath,
            badgeName: badge.badgeName,
            badgeType: badge.badgeType,
          )
        );
      }
      else if (totalTime >= 3000) {
        achievementBadges.add(
          Badges(
            badgeID: badge.badgeID,
            badgeImagePath: badge.badgeImagePath,
            badgeName: badge.badgeName,
            badgeType: badge.badgeType,
          )
        );
      }
    }
    for (var badge in achievementBadges) {
      print('You get ${badge.badgeID}');
    }
    return achievementBadges;
  }

  // Badge for calories burned
  Future<List<Badges>> todayCaloriesBurned(int countCalories, List<Badges> badges, String userID) async {
    //int convertedTargetCalories = int.parse(targetCalories);
    Badges badge;
    List<Badges> awardedBadges = [];

    if (countCalories >= 1 && countCalories < 100) {
      bool isBadgeAwarded = await isBadgeAwardedToUser('50_calories_burned', userID);
      if (!isBadgeAwarded) {
        badge = badges.firstWhere((badge) => badge.badgeID == '50_calories_burned', orElse: () => Badges());
        if (badge.badgeID != null) {
          awardedBadges.add(badge);
        }
      }
    }
    else if (countCalories >= 100 && countCalories < 500) {
      bool isBadgeAwarded = await isBadgeAwardedToUser('100_calories_burned', userID);
      if (!isBadgeAwarded) {
        badge = badges.firstWhere((badge) => badge.badgeID == '100_calories_burned', orElse: () => Badges());
        if (badge.badgeID != null) {
          awardedBadges.add(badge);
        }
      }
    }
    else if (countCalories >= 500 && countCalories < 1000) {
      bool isBadgeAwarded = await isBadgeAwardedToUser('500_calories_burned', userID);
      if (!isBadgeAwarded) {
      badge = badges.firstWhere((badge) => badge.badgeID == '500_calories_burned', orElse: () => Badges());
        if (badge.badgeID != null) {
          awardedBadges.add(badge);
        }
      }
    }
    else if (countCalories >= 1000 && countCalories < 3000) {
      bool isBadgeAwarded = await isBadgeAwardedToUser('1000_calories_burned', userID);
      if (!isBadgeAwarded) {
        badge = badges.firstWhere((badge) => badge.badgeID == '1000_calories_burned', orElse: () => Badges());
        if (badge.badgeID != null) {
          awardedBadges.add(badge);
        }
      }
    }
    else if (countCalories >= 3000) {
      bool isBadgeAwarded = await isBadgeAwardedToUser('3000_calories_burned', userID);
      if (!isBadgeAwarded) {
        badge = badges.firstWhere((badge) => badge.badgeID == '3000_calories_burned', orElse: () => Badges());
        if (badge.badgeID != null) {
          awardedBadges.add(badge);
        }
      }
    }
    else {
      null;
    }
    storeBadges(awardedBadges, userID);
    return awardedBadges;
  }
}