import '../models/sensor_model.dart';
import '../services/realtime_service.dart';

class SensorRepository {
  final RealtimeService _realtimeService;

  SensorRepository({RealtimeService? realtimeService})
      : _realtimeService = realtimeService ?? RealtimeService();

  Stream<SensorModel> sensorStream() => _realtimeService.sensorStream();

  Future<SensorModel> getSensorOnce() => _realtimeService.getSensorOnce();
}
