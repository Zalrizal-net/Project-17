import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/active_config_model.dart';
import '../models/planting_config_model.dart';
import '../repositories/config_repository.dart';

final configRepositoryProvider =
    Provider<ConfigRepository>((ref) => ConfigRepository());

// ─── Stream semua konfigurasi ────────────────────────────────────────────────

final plantingConfigsProvider =
    StreamProvider<List<PlantingConfigModel>>((ref) {
  return ref.watch(configRepositoryProvider).configsStream();
});

// ─── Stream konfigurasi aktif ────────────────────────────────────────────────

final activeConfigProvider = StreamProvider<ActiveConfigModel>((ref) {
  return ref.watch(configRepositoryProvider).activeConfigStream();
});

// ─── Notifier untuk CRUD + start/stop ────────────────────────────────────────

class ConfigNotifier extends StateNotifier<AsyncValue<void>> {
  final ConfigRepository _repo;

  ConfigNotifier(this._repo) : super(const AsyncValue.data(null));

  /// Tambah konfigurasi baru
  Future<String?> addConfig(PlantingConfigModel config) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.addConfig(config);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update konfigurasi yang ada
  Future<void> updateConfig(PlantingConfigModel config) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateConfig(config);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Hapus konfigurasi
  Future<void> deleteConfig(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteConfig(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Mulai jalankan konfigurasi
  Future<void> startConfig(PlantingConfigModel config) async {
    state = const AsyncValue.loading();
    try {
      await _repo.startConfig(config);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Hentikan konfigurasi aktif
  Future<void> stopConfig() async {
    state = const AsyncValue.loading();
    try {
      await _repo.stopConfig();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final configNotifierProvider =
    StateNotifierProvider<ConfigNotifier, AsyncValue<void>>((ref) {
  return ConfigNotifier(ref.watch(configRepositoryProvider));
});
