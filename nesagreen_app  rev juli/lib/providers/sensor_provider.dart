import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sensor_model.dart';
import '../repositories/sensor_repository.dart';

// Provider repository
final sensorRepositoryProvider = Provider<SensorRepository>((ref) {
  return SensorRepository();
});

// Stream provider sensor realtime
final sensorStreamProvider = StreamProvider<SensorModel>((ref) {
  final repo = ref.watch(sensorRepositoryProvider);
  return repo.sensorStream();
});
