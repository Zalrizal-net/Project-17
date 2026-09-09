class HistoryModel {
  final String date;
  final String hour;
  final double temperature;
  final double humidity;  // kelembapan udara
  final double soil;      // kelembapan tanah (BARU)
  final double light;
  final int timestamp;
  final String configName;   // nama konfigurasi aktif (BARU)
  final int dayNumber;       // hari ke berapa (BARU)
  final int wateringCount;   // jumlah siram hari itu (BARU)

  const HistoryModel({
    required this.date,
    required this.hour,
    required this.temperature,
    required this.humidity,
    required this.soil,
    required this.light,
    required this.timestamp,
    this.configName = '',
    this.dayNumber = 0,
    this.wateringCount = 0,
  });

  factory HistoryModel.fromMap({
    required String date,
    required String hour,
    required Map<dynamic, dynamic> map,
  }) {
    return HistoryModel(
      date: date,
      hour: hour,
      temperature: (map['temperature'] ?? 0).toDouble(),
      humidity: (map['humidity'] ?? 0).toDouble(),
      soil: (map['soil'] ?? 0).toDouble(),
      light: (map['light'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] ?? 0).toInt(),
      configName: map['config_name']?.toString() ?? '',
      dayNumber: (map['day_number'] ?? 0).toInt(),
      wateringCount: (map['watering_count'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'soil': soil,
      'light': light,
      'timestamp': timestamp,
      'config_name': configName,
      'day_number': dayNumber,
      'watering_count': wateringCount,
    };
  }
}
