class Formatter {
  Formatter._();

  /// Format suhu: "28°C"
  static String temperature(num value) => '${value.toStringAsFixed(0)}°C';

  /// Format kelembapan: "70%"
  static String humidity(num value) => '${value.toStringAsFixed(0)}%';

  /// Format intensitas cahaya: "300 LUX"
  static String lightLux(num value) => '${value.toStringAsFixed(0)} LUX';

  /// Format lux lowercase: "300 lux"
  static String lightLuxLower(num value) => '${value.toStringAsFixed(0)} lux';

  /// Format intensitas: "80%"
  static String intensity(num value) => '${value.toStringAsFixed(0)}%';

  /// Format desimal satu angka: "27.0"
  static String decimal1(num value) => value.toStringAsFixed(1);

  /// Format waktu jam: "07:00"
  static String hourMinute(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Parse "07:00" → [7, 0]
  static List<int> parseTime(String time) {
    final parts = time.split(':');
    return [int.parse(parts[0]), int.parse(parts[1])];
  }
}
