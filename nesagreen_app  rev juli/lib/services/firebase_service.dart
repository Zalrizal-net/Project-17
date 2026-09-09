import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// Get reference ke path tertentu
  DatabaseReference ref(String path) => _db.ref(path);

  /// Baca data sekali
  Future<DataSnapshot> readOnce(String path) async {
    return await _db.ref(path).get();
  }

  /// Tulis data ke path
  Future<void> write(String path, dynamic value) async {
    await _db.ref(path).set(value);
  }

  /// Update data di path (partial update)
  Future<void> update(String path, Map<String, dynamic> value) async {
    await _db.ref(path).update(value);
  }

  /// Stream data realtime
  Stream<DatabaseEvent> stream(String path) {
    return _db.ref(path).onValue;
  }
}
