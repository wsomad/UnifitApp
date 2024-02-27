// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mhs_application/models/student.dart';
import 'package:mhs_application/services/database.dart';

class AuthService {

  // Create firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  // Create a user object
  Student? _checkStudent(User? user) {
    return user != null ? Student(uid: user.uid) : null;
  }

  // Create a user stream
  Stream<Student?> get studentUserAuthentication {
    return _firebaseAuth.authStateChanges().map(_checkStudent);
  }

  // Sign Up with Email and Password
  Future signUpWithEmailAndPassword(String email, String password, Student student) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? newUser = userCredential.user;

      if (newUser != null) {
        print("New user created successfully: ${newUser.uid}");
        try {
          await _databaseService.createNewData('students/${newUser.uid}', student.toJson());
          print("Successfully created student data in the database");
        } catch (databaseError) {
          print("Error storing data in the database: $databaseError");
          // Handle the error as needed
          return false;
        }
      } 
      else {
        print("Failed to create user");
        return false;
      }

      return _checkStudent(newUser);
    } catch (e) {
      print("Error during signup: $e");
      return null;
    }
  }

  // Sign In with Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? existingUser = userCredential.user;
      return _checkStudent(existingUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

}