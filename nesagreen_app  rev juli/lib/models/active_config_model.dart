/// Model konfigurasi yang sedang aktif/berjalan
class ActiveConfigModel {
  final String configId;
  final String configName;
  final String startDate;   // format: 'YYYY-MM-DD'
  final int durationDays;   // total target hari
  final bool isRunning;

  const ActiveConfigModel({
    required this.configId,
    required this.configName,
    required this.startDate,
    required this.durationDays,
    required this.isRunning,
  });

  /// Hitung hari ke berapa sekarang (1-based)
  int get currentDay {
    if (!isRunning || startDate.isEmpty) return 0;
    try {
      final start = DateTime.parse(startDate);
      final now = DateTime.now();
      final startOnly = DateTime(start.year, start.month, start.day);
      final nowOnly = DateTime(now.year, now.month, now.day);
      final diff = nowOnly.difference(startOnly).inDays + 1;
      return diff.clamp(1, durationDays + 99); // biarkan melebihi jika belum dihentikan
    } catch (_) {
      return 0;
    }
  }

  bool get isCompleted => isRunning && currentDay > durationDays;

  factory ActiveConfigModel.fromMap(Map<dynamic, dynamic> map) {
    return ActiveConfigModel(
      configId: map['config_id']?.toString() ?? '',
      configName: map['config_name']?.toString() ?? '',
      startDate: map['start_date']?.toString() ?? '',
      durationDays: (map['duration_days'] ?? 0).toInt(),
      isRunning: map['is_running'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'config_id': configId,
      'config_name': configName,
      'start_date': startDate,
      'duration_days': durationDays,
      'is_running': isRunning,
    };
  }

  factory ActiveConfigModel.empty() {
    return const ActiveConfigModel(
      configId: '',
      configName: '',
      startDate: '',
      durationDays: 0,
      isRunning: false,
    );
  }

  ActiveConfigModel copyWith({
    String? configId,
    String? configName,
    String? startDate,
    int? durationDays,
    bool? isRunning,
  }) {
    return ActiveConfigModel(
      configId: configId ?? this.configId,
      configName: configName ?? this.configName,
      startDate: startDate ?? this.startDate,
      durationDays: durationDays ?? this.durationDays,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
