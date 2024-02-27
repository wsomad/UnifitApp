import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:mhs_application/models/student.dart';

class StudentDatabaseService {
  final String? uid;
  StudentDatabaseService({this.uid});
  final FirebaseDatabase studentReference =
        FirebaseDatabase.instance;
  StreamController<Student> controller = StreamController();

  Stream<Student> readCurrentStudentData(String dataPath) {
    final DatabaseReference studentReference =
        FirebaseDatabase.instance.ref(dataPath);
    
    return studentReference.onValue.map((event) {
      try {
        if (event.snapshot.value != null) {
          Map<Object?, Object?> rawData = event.snapshot.value as Map<Object?, Object?>;

          Map<String, dynamic> data = json.decode(json.encode(rawData));

          return Student.fromJson(data);
        } else {
          return Student();
        }
      } catch (e) {
        print('Error fetching current student data: $e');
        return Student(); // Return a default value or handle the error accordingly
      }
    });
  }
/*
  Stream<Student> get studentData {
    return studentReference.ref('students/$uid/personal').onValue.map((event) {
      Map<Object?, Object?> rawData = event.snapshot.value as Map<Object?, Object?>;

      Map<String, dynamic> data = json.decode(json.encode(rawData));
      return Student.fromJson(data);
    });
  }*/
}