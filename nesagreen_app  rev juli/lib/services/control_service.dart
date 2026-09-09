import '../core/constants/firebase_paths.dart';
import '../models/light_model.dart';
import '../models/sprinkler_model.dart';
import 'firebase_service.dart';

class ControlService {
  final FirebaseService _firebaseService;

  ControlService({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  // ─── LAMP 1 ──────────────────────────────────────────────────────

  Future<Lamp1Model> getLamp1() async {
    final snap = await _firebaseService.readOnce(FirebasePaths.lamp1);
    if (!snap.exists || snap.value == null) return Lamp1Model.defaultValue();
    return Lamp1Model.fromMap(snap.value as Map<dynamic, dynamic>);
  }

  Stream<Lamp1Model> lamp1Stream() {
    return _firebaseService.stream(FirebasePaths.lamp1).map((event) {
      final data = event.snapshot.value;
      if (data == null) return Lamp1Model.defaultValue();
      return Lamp1Model.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  Future<void> setLamp1Status(bool status) async {
    await _firebaseService.write(FirebasePaths.lamp1Status, status);
  }

  // ─── LAMP 2 ──────────────────────────────────────────────────────

  Future<Lamp2Model> getLamp2() async {
    final snap = await _firebaseService.readOnce(FirebasePaths.lamp2);
    if (!snap.exists || snap.value == null) return Lamp2Model.defaultValue();
    return Lamp2Model.fromMap(snap.value as Map<dynamic, dynamic>);
  }

  Stream<Lamp2Model> lamp2Stream() {
    return _firebaseService.stream(FirebasePaths.lamp2).map((event) {
      final data = event.snapshot.value;
      if (data == null) return Lamp2Model.defaultValue();
      return Lamp2Model.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  Future<void> setLamp2Status(bool status) async {
    await _firebaseService.write(FirebasePaths.lamp2Status, status);
  }

  // ─── SPRINKLER ───────────────────────────────────────────────────

  Future<SprinklerModel> getSprinkler() async {
    final snap = await _firebaseService.readOnce(FirebasePaths.sprinkler);
    if (!snap.exists || snap.value == null) return SprinklerModel.defaultValue();
    return SprinklerModel.fromMap(snap.value as Map<dynamic, dynamic>);
  }

  Stream<SprinklerModel> sprinklerStream() {
    return _firebaseService.stream(FirebasePaths.sprinkler).map((event) {
      final data = event.snapshot.value;
      if (data == null) return SprinklerModel.defaultValue();
      return SprinklerModel.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  Future<void> setSprinklerStatus(bool status) async {
    await _firebaseService.write(FirebasePaths.sprinklerStatus, status);
  }

  Future<void> updateSprinkler(SprinklerModel sprinkler) async {
    await _firebaseService.write(FirebasePaths.sprinkler, sprinkler.toMap());
  }
}
