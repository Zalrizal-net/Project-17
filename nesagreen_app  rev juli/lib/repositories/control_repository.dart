import '../models/light_model.dart';
import '../models/sprinkler_model.dart';
import '../services/control_service.dart';

class ControlRepository {
  final ControlService _controlService;

  ControlRepository({ControlService? controlService})
      : _controlService = controlService ?? ControlService();

  // LAMP 1
  Future<Lamp1Model> getLamp1() => _controlService.getLamp1();
  Stream<Lamp1Model> lamp1Stream() => _controlService.lamp1Stream();
  Future<void> setLamp1Status(bool status) => _controlService.setLamp1Status(status);

  // LAMP 2
  Future<Lamp2Model> getLamp2() => _controlService.getLamp2();
  Stream<Lamp2Model> lamp2Stream() => _controlService.lamp2Stream();
  Future<void> setLamp2Status(bool status) => _controlService.setLamp2Status(status);

  // SPRINKLER
  Future<SprinklerModel> getSprinkler() => _controlService.getSprinkler();
  Stream<SprinklerModel> sprinklerStream() => _controlService.sprinklerStream();
  Future<void> setSprinklerStatus(bool status) => _controlService.setSprinklerStatus(status);
  Future<void> updateSprinkler(SprinklerModel sprinkler) => _controlService.updateSprinkler(sprinkler);
}
