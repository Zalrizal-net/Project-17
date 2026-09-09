import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/light_model.dart';
import '../models/planting_config_model.dart';
import '../models/sprinkler_model.dart';
import '../repositories/control_repository.dart';

final controlRepositoryProvider =
    Provider<ControlRepository>((ref) => ControlRepository());

// ─── LAMP 1 ──────────────────────────────────────────────────────────────────

final lamp1StreamProvider = StreamProvider<Lamp1Model>((ref) {
  return ref.watch(controlRepositoryProvider).lamp1Stream();
});

class Lamp1Notifier extends StateNotifier<Lamp1Model> {
  final ControlRepository _repo;
  Lamp1Notifier(this._repo) : super(Lamp1Model.defaultValue()) {
    _load();
  }

  Future<void> _load() async => state = await _repo.getLamp1();

  Future<void> setStatus(bool status) async {
    state = state.copyWith(status: status);
    await _repo.setLamp1Status(status);
  }
}

final lamp1NotifierProvider =
    StateNotifierProvider<Lamp1Notifier, Lamp1Model>((ref) {
  return Lamp1Notifier(ref.watch(controlRepositoryProvider));
});

// ─── LAMP 2 ──────────────────────────────────────────────────────────────────

final lamp2StreamProvider = StreamProvider<Lamp2Model>((ref) {
  return ref.watch(controlRepositoryProvider).lamp2Stream();
});

class Lamp2Notifier extends StateNotifier<Lamp2Model> {
  final ControlRepository _repo;
  Lamp2Notifier(this._repo) : super(Lamp2Model.defaultValue()) {
    _load();
  }

  Future<void> _load() async => state = await _repo.getLamp2();

  Future<void> setStatus(bool status) async {
    state = state.copyWith(status: status);
    await _repo.setLamp2Status(status);
  }
}

final lamp2NotifierProvider =
    StateNotifierProvider<Lamp2Notifier, Lamp2Model>((ref) {
  return Lamp2Notifier(ref.watch(controlRepositoryProvider));
});

// ─── SPRINKLER ────────────────────────────────────────────────────────────────

final sprinklerStreamProvider = StreamProvider<SprinklerModel>((ref) {
  return ref.watch(controlRepositoryProvider).sprinklerStream();
});

class SprinklerNotifier extends StateNotifier<SprinklerModel> {
  final ControlRepository _repo;
  SprinklerNotifier(this._repo) : super(SprinklerModel.defaultValue()) {
    _load();
  }

  Future<void> _load() async => state = await _repo.getSprinkler();

  Future<void> setStatus(bool v) async {
    state = state.copyWith(status: v);
    await _repo.setSprinklerStatus(v);
  }

  void setAutoMode(bool v) => state = state.copyWith(autoMode: v);
  void setMode(WateringMode m) => state = state.copyWith(mode: m);
  void setSoilThreshold(int v) => state = state.copyWith(soilThreshold: v);
  void setDuration(int seconds) => state = state.copyWith(duration: seconds);

  void addSchedule() {
    if (state.schedules.length >= 8) return;
    final newSchedules = List<ScheduleItem>.from(state.schedules)
      ..add(const ScheduleItem(time: '12:00', enabled: true));
    state = state.copyWith(schedules: newSchedules);
  }

  void removeSchedule(int index) {
    if (state.schedules.length <= 1) return;
    final newSchedules = List<ScheduleItem>.from(state.schedules)..removeAt(index);
    state = state.copyWith(schedules: newSchedules);
  }

  void updateScheduleTime(int index, String time) {
    final newSchedules = List<ScheduleItem>.from(state.schedules);
    newSchedules[index] = newSchedules[index].copyWith(time: time);
    state = state.copyWith(schedules: newSchedules);
  }

  void updateScheduleEnabled(int index, bool enabled) {
    final newSchedules = List<ScheduleItem>.from(state.schedules);
    newSchedules[index] = newSchedules[index].copyWith(enabled: enabled);
    state = state.copyWith(schedules: newSchedules);
  }

  Future<void> saveSettings() async =>
      await _repo.updateSprinkler(state);
}

final sprinklerNotifierProvider =
    StateNotifierProvider<SprinklerNotifier, SprinklerModel>((ref) {
  return SprinklerNotifier(ref.watch(controlRepositoryProvider));
});
