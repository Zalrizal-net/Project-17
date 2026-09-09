class FirebasePaths {
  FirebasePaths._();

  // ── Realtime sensor ─────────────────────────────────────────────
  static const String realtime            = 'iot/realtime';
  static const String realtimeTemperature = 'iot/realtime/temperature';
  static const String realtimeHumidity    = 'iot/realtime/humidity';
  static const String realtimeSoil        = 'iot/realtime/soil';      // BARU
  static const String realtimeLight       = 'iot/realtime/light';
  static const String realtimeTimestamp   = 'iot/realtime/timestamp';

  // ── History ──────────────────────────────────────────────────────
  static const String history = 'iot/history';
  static String historyByDate(String date) => 'iot/history/$date';
  static String historyByDateAndHour(String date, String hour) => 'iot/history/$date/$hour';

  // ── Control: Lampu ───────────────────────────────────────────────
  static const String control      = 'iot/control';
  static const String lamp1        = 'iot/control/lamp1';
  static const String lamp1Status  = 'iot/control/lamp1/status';
  static const String lamp2        = 'iot/control/lamp2';
  static const String lamp2Status  = 'iot/control/lamp2/status';

  // ── Control: Sprinkler ──────────────────────────────────────────
  static const String sprinkler          = 'iot/control/sprinkler';
  static const String sprinklerStatus    = 'iot/control/sprinkler/status';
  static const String sprinklerAutoMode  = 'iot/control/sprinkler/auto_mode';
  static const String sprinklerMode      = 'iot/control/sprinkler/mode';           // BARU
  static const String sprinklerThreshold = 'iot/control/sprinkler/soil_threshold'; // BARU
  static const String sprinklerDuration  = 'iot/control/sprinkler/duration';
  static const String sprinklerSchedules = 'iot/control/sprinkler/schedules';

  // ── Konfigurasi Penanaman ────────────────────────────────────────
  static const String configurations  = 'iot/configurations';                       // BARU
  static String configById(String id) => 'iot/configurations/$id';                 // BARU

  // ── Konfigurasi Aktif ────────────────────────────────────────────
  static const String activeConfig = 'iot/active_config';                           // BARU

  // ── FCM Token ────────────────────────────────────────────────────
  static const String fcmToken = 'iot/fcm_token';                                   // BARU

  // ── Status perangkat ESP32 ───────────────────────────────────────
  static const String deviceStatus   = 'iot/device_status';
  static const String deviceLastSeen = 'iot/device_status/last_seen';
  static const String deviceOnline   = 'iot/device_status/online';
}
