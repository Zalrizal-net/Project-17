import 'package:firebase_database/firebase_database.dart';
import '../core/constants/firebase_paths.dart';
import '../models/active_config_model.dart';
import '../models/planting_config_model.dart';
import 'firebase_service.dart';

class ConfigService {
  final FirebaseService _firebaseService;

  ConfigService({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  // ─── CRUD Konfigurasi ────────────────────────────────────────────

  /// Ambil semua konfigurasi
  Future<List<PlantingConfigModel>> getAllConfigs() async {
    final snap = await _firebaseService.readOnce(FirebasePaths.configurations);
    if (!snap.exists || snap.value == null) return [];

    final data = snap.value as Map<dynamic, dynamic>;
    final List<PlantingConfigModel> result = [];
    data.forEach((id, value) {
      if (value is Map) {
        result.add(PlantingConfigModel.fromMap(
          id.toString(),
          Map<dynamic, dynamic>.from(value),
        ));
      }
    });
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  /// Stream semua konfigurasi
  Stream<List<PlantingConfigModel>> configsStream() {
    return _firebaseService
        .stream(FirebasePaths.configurations)
        .map((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data == null) return <PlantingConfigModel>[];

      final map = data as Map<dynamic, dynamic>;
      final List<PlantingConfigModel> result = [];
      map.forEach((id, value) {
        if (value is Map) {
          result.add(PlantingConfigModel.fromMap(
            id.toString(),
            Map<dynamic, dynamic>.from(value),
          ));
        }
      });
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return result;
    });
  }

  /// Simpan konfigurasi baru (generate ID dari push)
  Future<String> addConfig(PlantingConfigModel config) async {
    final ref = FirebaseDatabase.instance
        .ref(FirebasePaths.configurations)
        .push();
    await ref.set(config.toMap());
    return ref.key ?? '';
  }

  /// Update konfigurasi yang ada
  Future<void> updateConfig(PlantingConfigModel config) async {
    await _firebaseService.write(
      FirebasePaths.configById(config.id),
      config.toMap(),
    );
  }

  /// Hapus konfigurasi
  Future<void> deleteConfig(String id) async {
    await FirebaseDatabase.instance
        .ref(FirebasePaths.configById(id))
        .remove();
  }

  // ─── Konfigurasi Aktif ───────────────────────────────────────────

  /// Stream konfigurasi aktif
  Stream<ActiveConfigModel> activeConfigStream() {
    return _firebaseService
        .stream(FirebasePaths.activeConfig)
        .map((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data == null) return ActiveConfigModel.empty();
      return ActiveConfigModel.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  /// Ambil konfigurasi aktif sekali
  Future<ActiveConfigModel> getActiveConfig() async {
    final snap = await _firebaseService.readOnce(FirebasePaths.activeConfig);
    if (!snap.exists || snap.value == null) return ActiveConfigModel.empty();
    return ActiveConfigModel.fromMap(snap.value as Map<dynamic, dynamic>);
  }

  /// Mulai jalankan konfigurasi
  Future<void> startConfig(PlantingConfigModel config) async {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final activeModel = ActiveConfigModel(
      configId: config.id,
      configName: config.name,
      startDate: dateStr,
      durationDays: config.durationDays,
      isRunning: true,
    );
    await _firebaseService.write(
        FirebasePaths.activeConfig, activeModel.toMap());
  }

  /// Hentikan konfigurasi aktif
  Future<void> stopConfig() async {
    await _firebaseService.write(FirebasePaths.activeConfig, {
      'config_id': '',
      'config_name': '',
      'start_date': '',
      'duration_days': 0,
      'is_running': false,
    });
  }

  // ─── FCM Token ───────────────────────────────────────────────────

  Future<void> saveFcmToken(String token) async {
    await _firebaseService.write(FirebasePaths.fcmToken, token);
  }
}
