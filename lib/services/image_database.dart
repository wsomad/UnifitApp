import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhs_application/services/student_database.dart';

class ImageDatabaseService {

  File? image;
  final DatabaseReference studentReference = FirebaseDatabase.instance.ref();

  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      final storageRef = FirebaseStorage.instance.ref().child('user_image/$userId/$fileName');
      final uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image Uploaded'));
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String imageUrl = await downloadUrl.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfilePicture(String userId, String imageUrl) async {
    try {
      await studentReference.child('students/$userId/personal').update({
        'profile': imageUrl
      });
    } catch (e) {
      print('Error updating profile picture in database: $e');
      rethrow;
    }
  }
}