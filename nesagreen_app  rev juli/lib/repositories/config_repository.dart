import '../models/active_config_model.dart';
import '../models/planting_config_model.dart';
import '../services/config_service.dart';

class ConfigRepository {
  final ConfigService _configService;

  ConfigRepository({ConfigService? configService})
      : _configService = configService ?? ConfigService();

  // Konfigurasi CRUD
  Future<List<PlantingConfigModel>> getAllConfigs() => _configService.getAllConfigs();
  Stream<List<PlantingConfigModel>> configsStream() => _configService.configsStream();
  Future<String> addConfig(PlantingConfigModel config) => _configService.addConfig(config);
  Future<void> updateConfig(PlantingConfigModel config) => _configService.updateConfig(config);
  Future<void> deleteConfig(String id) => _configService.deleteConfig(id);

  // Konfigurasi Aktif
  Stream<ActiveConfigModel> activeConfigStream() => _configService.activeConfigStream();
  Future<ActiveConfigModel> getActiveConfig() => _configService.getActiveConfig();
  Future<void> startConfig(PlantingConfigModel config) => _configService.startConfig(config);
  Future<void> stopConfig() => _configService.stopConfig();
}
