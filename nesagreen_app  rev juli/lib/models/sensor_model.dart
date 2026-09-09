class SensorModel {
  final double temperature;
  final double humidity; // kelembapan udara
  final double soil;     // kelembapan tanah
  final double light;
  final int timestamp;

  const SensorModel({
    required this.temperature,
    required this.humidity,
    required this.soil,
    required this.light,
    required this.timestamp,
  });

  factory SensorModel.fromMap(Map<dynamic, dynamic> map) {
    return SensorModel(
      temperature: (map['temperature'] ?? 0).toDouble(),
      humidity: (map['humidity'] ?? 0).toDouble(),
      soil: (map['soil'] ?? 0).toDouble(),
      light: (map['light'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'soil': soil,
      'light': light,
      'timestamp': timestamp,
    };
  }

  factory SensorModel.empty() {
    return const SensorModel(
      temperature: 0,
      humidity: 0,
      soil: 0,
      light: 0,
      timestamp: 0,
    );
  }

  SensorModel copyWith({
    double? temperature,
    double? humidity,
    double? soil,
    double? light,
    int? timestamp,
  }) {
    return SensorModel(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      soil: soil ?? this.soil,
      light: light ?? this.light,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
