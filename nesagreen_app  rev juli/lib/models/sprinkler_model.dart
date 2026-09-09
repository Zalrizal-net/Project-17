import 'planting_config_model.dart';

class ScheduleItem {
  final String time;
  final bool enabled;

  const ScheduleItem({required this.time, required this.enabled});

  factory ScheduleItem.fromMap(Map<dynamic, dynamic> map) {
    return ScheduleItem(
      time: map['time']?.toString() ?? '07:00',
      enabled: map['enabled'] == true,
    );
  }

  Map<String, dynamic> toMap() => {'time': time, 'enabled': enabled};

  ScheduleItem copyWith({String? time, bool? enabled}) =>
      ScheduleItem(time: time ?? this.time, enabled: enabled ?? this.enabled);
}

class SprinklerModel {
  final bool status;
  final bool autoMode;
  final WateringMode mode;     // 'time' or 'soil'
  final int soilThreshold;     // 0–100, trigger siram jika soil < nilai ini
  final int duration;          // detik per penyiraman
  final List<ScheduleItem> schedules;

  const SprinklerModel({
    required this.status,
    required this.autoMode,
    required this.mode,
    required this.soilThreshold,
    required this.duration,
    required this.schedules,
  });

  factory SprinklerModel.fromMap(Map<dynamic, dynamic> map) {
    List<ScheduleItem> schedules = [];

    if (map['schedules'] != null) {
      final raw = map['schedules'];
      if (raw is List) {
        for (final item in raw) {
          if (item is Map) schedules.add(ScheduleItem.fromMap(Map<dynamic, dynamic>.from(item)));
        }
      } else if (raw is Map) {
        final sorted = raw.entries.toList()
          ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
        for (final entry in sorted) {
          if (entry.value is Map) {
            schedules.add(ScheduleItem.fromMap(Map<dynamic, dynamic>.from(entry.value as Map)));
          }
        }
      }
    } else if (map['schedule'] != null) {
      final s = map['schedule'] as Map;
      if (s['morning'] != null) schedules.add(ScheduleItem.fromMap(Map<dynamic, dynamic>.from(s['morning'] as Map)));
      if (s['evening'] != null) schedules.add(ScheduleItem.fromMap(Map<dynamic, dynamic>.from(s['evening'] as Map)));
    }

    if (schedules.isEmpty) {
      schedules = [
        const ScheduleItem(time: '07:00', enabled: true),
        const ScheduleItem(time: '17:00', enabled: true),
      ];
    }

    final modeStr = map['mode']?.toString() ?? 'time';

    return SprinklerModel(
      status: map['status'] == true,
      autoMode: map['auto_mode'] == true,
      mode: modeStr == 'soil' ? WateringMode.soil : WateringMode.time,
      soilThreshold: (map['soil_threshold'] ?? 40).toInt(),
      duration: (map['duration'] ?? 30).toInt(),
      schedules: schedules,
    );
  }

  Map<String, dynamic> toMap() => {
    'status': status,
    'auto_mode': autoMode,
    'mode': mode == WateringMode.soil ? 'soil' : 'time',
    'soil_threshold': soilThreshold,
    'duration': duration,
    'schedules': schedules.asMap().map((k, v) => MapEntry(k.toString(), v.toMap())),
  };

  factory SprinklerModel.defaultValue() => const SprinklerModel(
    status: false,
    autoMode: false,
    mode: WateringMode.time,
    soilThreshold: 40,
    duration: 30,
    schedules: [
      ScheduleItem(time: '07:00', enabled: true),
      ScheduleItem(time: '17:00', enabled: true),
    ],
  );

  SprinklerModel copyWith({
    bool? status,
    bool? autoMode,
    WateringMode? mode,
    int? soilThreshold,
    int? duration,
    List<ScheduleItem>? schedules,
  }) => SprinklerModel(
    status: status ?? this.status,
    autoMode: autoMode ?? this.autoMode,
    mode: mode ?? this.mode,
    soilThreshold: soilThreshold ?? this.soilThreshold,
    duration: duration ?? this.duration,
    schedules: schedules ?? this.schedules,
  );
}
