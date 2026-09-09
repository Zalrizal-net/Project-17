import 'package:firebase_database/firebase_database.dart';
import '../core/constants/firebase_paths.dart';
import '../models/sensor_model.dart';
import 'firebase_service.dart';

class RealtimeService {
  final FirebaseService _firebaseService;

  RealtimeService({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  /// Stream data sensor realtime
  Stream<SensorModel> sensorStream() {
    return _firebaseService
        .stream(FirebasePaths.realtime)
        .map((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data == null) return SensorModel.empty();
      return SensorModel.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  /// Ambil data sensor sekali
  Future<SensorModel> getSensorOnce() async {
    final snapshot = await _firebaseService.readOnce(FirebasePaths.realtime);
    if (!snapshot.exists || snapshot.value == null) return SensorModel.empty();
    return SensorModel.fromMap(snapshot.value as Map<dynamic, dynamic>);
  }
}
