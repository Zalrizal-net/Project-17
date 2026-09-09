import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'config_service.dart';

/// Handler untuk background FCM message (harus top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message sudah ditampilkan otomatis oleh FCM di Android
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'microgreen_channel';
  static const _channelName = 'Microgreen IoT';
  static const _channelDesc = 'Notifikasi pengingat konfigurasi penanaman';

  /// Inisialisasi service notifikasi
  Future<void> initialize() async {
    if (kIsWeb) {
      // Lewati setup FCM & Local Notifications di Web agar tidak crash 
      // (karena butuh firebase-messaging-sw.js)
      return;
    }

    try {
      // Minta izin notifikasi
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Setup local notifications
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await _localNotifications.initialize(initSettings);

      // Buat channel Android
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Handle FCM saat app di foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background handler (top-level function)
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Simpan FCM token ke Firebase
      await _saveFcmToken();

      // Refresh token listener
      _messaging.onTokenRefresh.listen((newToken) {
        ConfigService().saveFcmToken(newToken);
      });
    } catch (e) {
      // Abaikan error setup notifikasi
      debugPrint('Error initialize FCM: $e');
    }
  }

  /// Handle pesan FCM saat foreground
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// Simpan FCM token ke Firebase RTDB
  Future<void> _saveFcmToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await ConfigService().saveFcmToken(token);
    }
  }
}
