class Validator {
  Validator._();

  /// Validasi format waktu "HH:mm"
  static bool isValidTime(String time) {
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return regex.hasMatch(time);
  }

  /// Validasi nilai intensitas slider (0–100)
  static bool isValidIntensity(double value) {
    return value >= 0 && value <= 100;
  }

  /// Validasi nilai suhu sensor (0–60°C)
  static bool isValidTemperature(num value) {
    return value >= 0 && value <= 60;
  }

  /// Validasi nilai kelembapan (0–100%)
  static bool isValidHumidity(num value) {
    return value >= 0 && value <= 100;
  }

  /// Validasi nilai cahaya lux (0–100000)
  static bool isValidLight(num value) {
    return value >= 0 && value <= 100000;
  }
}
