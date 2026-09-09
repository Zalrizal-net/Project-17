import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Status koneksi USER (browser/HP) ke Firebase ─────────────────
final userOnlineProvider = StreamProvider<bool>((ref) {
  return FirebaseDatabase.instance
      .ref('.info/connected')
      .onValue
      .map((event) => event.snapshot.value == true);
});

// ── Status ESP32 (cek last_seen timestamp) ────────────────────────
// ESP32 dianggap online jika last_seen < 15 detik yang lalu
final deviceStatusProvider = StreamProvider<DeviceStatus>((ref) {
  return FirebaseDatabase.instance
      .ref('iot/device_status')
      .onValue
      .map((event) {
    final data = event.snapshot.value;
    if (data == null) return DeviceStatus.unknown();

    final map = Map<dynamic, dynamic>.from(data as Map);
    final lastSeen = (map['last_seen'] ?? 0) as int;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final diff = now - lastSeen;

    return DeviceStatus(
      isOnline: diff < 15, // online jika < 15 detik
      lastSeen: lastSeen,
      secondsAgo: diff,
    );
  });
});

class DeviceStatus {
  final bool isOnline;
  final int lastSeen;
  final int secondsAgo;

  const DeviceStatus({
    required this.isOnline,
    required this.lastSeen,
    required this.secondsAgo,
  });

  factory DeviceStatus.unknown() =>
      const DeviceStatus(isOnline: false, lastSeen: 0, secondsAgo: 9999);

  String get lastSeenText {
    if (secondsAgo >= 9999) return 'Belum pernah terhubung';
    if (secondsAgo < 60) return '${secondsAgo}d yang lalu';
    if (secondsAgo < 3600) return '${secondsAgo ~/ 60}m yang lalu';
    return '${secondsAgo ~/ 3600}j yang lalu';
  }
}
