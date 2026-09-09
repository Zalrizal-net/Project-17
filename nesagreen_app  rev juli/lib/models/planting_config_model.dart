/// Mode penyiraman: berdasarkan jadwal waktu atau sensor tanah
enum WateringMode { time, soil }

/// Model konfigurasi penanaman yang disimpan oleh user
class PlantingConfigModel {
  final String id;
  final String name;
  final int durationDays;       // target total hari
  final int lamp1DelayDays;     // hari ke berapa lampu 1 mulai nyala (min 2)
  final int lamp2DelayDays;     // hari ke berapa lampu 2 mulai nyala (min 2)
  final WateringMode wateringMode;
  final int soilThreshold;      // 0-100, siram jika soil < nilai ini (mode soil)
  final List<String> wateringTimes; // jam penyiraman ["07:00","17:00"] (mode time)
  final int wateringDuration;   // durasi penyiraman (detik)
  final int wateringPerDay;     // jumlah penyiraman per hari (mode time)
  final int createdAt;          // unix timestamp

  const PlantingConfigModel({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.lamp1DelayDays,
    required this.lamp2DelayDays,
    required this.wateringMode,
    required this.soilThreshold,
    required this.wateringTimes,
    required this.wateringDuration,
    required this.wateringPerDay,
    required this.createdAt,
  });

  factory PlantingConfigModel.fromMap(String id, Map<dynamic, dynamic> map) {
    final modeStr = map['watering_mode']?.toString() ?? 'time';
    final times = <String>[];
    if (map['watering_times'] != null) {
      final raw = map['watering_times'];
      if (raw is List) {
        for (final t in raw) times.add(t.toString());
      } else if (raw is Map) {
        final sorted = raw.entries.toList()
          ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
        for (final e in sorted) times.add(e.value.toString());
      }
    }
    if (times.isEmpty) times.addAll(['07:00', '17:00']);

    return PlantingConfigModel(
      id: id,
      name: map['name']?.toString() ?? 'Tanaman',
      durationDays: (map['duration_days'] ?? 14).toInt(),
      lamp1DelayDays: (map['lamp1_delay_days'] ?? 2).toInt(),
      lamp2DelayDays: (map['lamp2_delay_days'] ?? 2).toInt(),
      wateringMode: modeStr == 'soil' ? WateringMode.soil : WateringMode.time,
      soilThreshold: (map['soil_threshold'] ?? 40).toInt(),
      wateringTimes: times,
      wateringDuration: (map['watering_duration'] ?? 30).toInt(),
      wateringPerDay: (map['watering_per_day'] ?? 2).toInt(),
      createdAt: (map['created_at'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration_days': durationDays,
      'lamp1_delay_days': lamp1DelayDays,
      'lamp2_delay_days': lamp2DelayDays,
      'watering_mode': wateringMode == WateringMode.soil ? 'soil' : 'time',
      'soil_threshold': soilThreshold,
      'watering_times': wateringTimes.asMap().map((k, v) => MapEntry(k.toString(), v)),
      'watering_duration': wateringDuration,
      'watering_per_day': wateringPerDay,
      'created_at': createdAt,
    };
  }

  PlantingConfigModel copyWith({
    String? id,
    String? name,
    int? durationDays,
    int? lamp1DelayDays,
    int? lamp2DelayDays,
    WateringMode? wateringMode,
    int? soilThreshold,
    List<String>? wateringTimes,
    int? wateringDuration,
    int? wateringPerDay,
    int? createdAt,
  }) {
    return PlantingConfigModel(
      id: id ?? this.id,
      name: name ?? this.name,
      durationDays: durationDays ?? this.durationDays,
      lamp1DelayDays: lamp1DelayDays ?? this.lamp1DelayDays,
      lamp2DelayDays: lamp2DelayDays ?? this.lamp2DelayDays,
      wateringMode: wateringMode ?? this.wateringMode,
      soilThreshold: soilThreshold ?? this.soilThreshold,
      wateringTimes: wateringTimes ?? this.wateringTimes,
      wateringDuration: wateringDuration ?? this.wateringDuration,
      wateringPerDay: wateringPerDay ?? this.wateringPerDay,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static PlantingConfigModel defaultConfig() {
    return PlantingConfigModel(
      id: '',
      name: 'Konfigurasi Baru',
      durationDays: 14,
      lamp1DelayDays: 2,
      lamp2DelayDays: 2,
      wateringMode: WateringMode.time,
      soilThreshold: 40,
      wateringTimes: ['07:00', '17:00'],
      wateringDuration: 30,
      wateringPerDay: 2,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }
}
