import 'package:firebase_database/firebase_database.dart';

class DatabaseService<T> {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  // Create new record
  Future<void> createNewData(String dataPath, Map<String, dynamic> data) async {
    await _databaseReference.child(dataPath).set(data);
  }

  // Read data from database
  Future readData(String dataPath) async {
    return await _databaseReference.child(dataPath).once();
  }

  // Write data from database
  Future<void> updateData(String dataPath, Map<String, dynamic> data) async {
    await _databaseReference.child(dataPath).update(data);
  }

  // Add a list of data to a specific node without affecting existing data
  Future<void> addListData(String dataPath, List<Map<String, dynamic>> dataList) async {
    for (var data in dataList) {
      await _databaseReference.child(dataPath).push().set(data);
    }
  }

  // Delete data from database
  Future<void> deleteData(String dataPath) async {
    await _databaseReference.child(dataPath).remove();
  }

}