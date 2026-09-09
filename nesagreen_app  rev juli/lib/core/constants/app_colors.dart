import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Green
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFE8F5E9);

  // Accent
  static const Color accent = Color(0xFF66BB6A);
  static const Color accentLight = Color(0xFFA5D6A7);

  // Background
  static const Color background = Color(0xFFF9FBF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Sensor Colors
  static const Color humidity = Color(0xFF1E88E5);       // kelembapan udara - biru
  static const Color humidityLight = Color(0xFFE3F2FD);
  static const Color soil = Color(0xFF795548);           // kelembapan tanah - coklat (BARU)
  static const Color soilLight = Color(0xFFEFEBE9);      // (BARU)
  static const Color light = Color(0xFFFB8C00);          // cahaya - oranye
  static const Color lightColor = Color(0xFFFFF3E0);
  static const Color temperature = Color(0xFFE53935);    // suhu - merah
  static const Color temperatureLight = Color(0xFFFFEBEE);

  // Chart Colors
  static const Color chartTemperature = Color(0xFFEF5350);
  static const Color chartHumidity = Color(0xFF42A5F5);
  static const Color chartSoil = Color(0xFF8D6E63);     // BARU
  static const Color chartLight = Color(0xFFFFB300);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status
  static const Color active = Color(0xFF4CAF50);
  static const Color inactive = Color(0xFF9E9E9E);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Lamp colors
  static const Color lamp1Color = Color(0xFFFFC107);    // kuning/amber untuk lampu 1
  static const Color lamp2Color = Color(0xFFFF7043);    // oranye untuk lampu 2

  // Bottom Nav
  static const Color navBackground = Color(0xFF1B5E20);
  static const Color navActive = Color(0xFFFFC107);
  static const Color navInactive = Color(0xFFFFFFFF);

  // Divider
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Button
  static const Color buttonPrimary = Color(0xFF1565C0);
  static const Color buttonSave = Color(0xFF1976D2);
}
