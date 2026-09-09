class DateHelper {
  DateHelper._();

  /// Format DateTime ke key tanggal Firebase: "2026-05-09"
  static String toDateKey(DateTime date) {
    return '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
  }

  /// Format DateTime ke key jam Firebase: "07:00"
  static String toHourKey(DateTime date) {
    return '${_pad(date.hour)}:00';
  }

  /// Konversi timestamp Unix ke DateTime
  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  /// Konversi DateTime ke timestamp Unix
  static int toTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch ~/ 1000;
  }

  /// Ambil tanggal hari ini sebagai key Firebase
  static String todayKey() {
    return toDateKey(DateTime.now());
  }

  /// Ambil list tanggal untuk 7 hari terakhir
  static List<String> lastWeekKeys() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: i));
      return toDateKey(date);
    });
  }

  /// Format tampilan tanggal: "Sabtu, 9 Mei 2026"
  static String formatDisplay(DateTime date) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    const days = [
      '', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    return '${days[date.weekday]}, ${date.day} ${months[date.month]} ${date.year}';
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
