class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'microgreen';
  static const String appTitle = 'Microgreen IoT';

  // Navigation
  static const String navHome = 'Beranda';
  static const String navManual = 'Manual';
  static const String navChart = 'Grafik';
  static const String navHistory = 'History';
  static const String navSettings = 'Pengaturan';

  // Home Page
  static const String currentCondition = 'Kondisi saat ini';
  static const String activeConfig = 'Konfigurasi Aktif';
  static const String lampStatus = 'Status Lampu';
  static const String sprinklerStatus2 = 'Status Penyiraman';
  static const String menu = 'Akses Cepat';
  static const String viewChart = 'Grafik';
  static const String manualMode = 'Manual';
  static const String history = 'History';
  static const String settings = 'Pengaturan';
  static const String noActiveConfig = 'Tidak ada konfigurasi berjalan';

  // Sensor Labels
  static const String humidity = 'Kelembapan Udara';
  static const String soil = 'Kelembapan Tanah';
  static const String light = 'Cahaya';
  static const String temperature = 'Suhu';

  // Units
  static const String unitCelsius = '°C';
  static const String unitPercent = '%';
  static const String unitLux = 'LUX';
  static const String unitLuxLower = 'lux';

  // Manual Page
  static const String pageManual = 'Mode Manual';
  static const String lamp1 = 'Lampu 1';
  static const String lamp2 = 'Lampu 2';
  static const String sprinklerManual = 'Siram Manual';
  static const String warningAutoMode =
      'Peringatan: Mode otomatis aktif.\nPerubahan manual akan diterapkan sementara.';

  // Sprinkler
  static const String sprinklerControl = 'Kontrol Sprinkler';
  static const String sprinklerStatus = 'Status Sprinkler';
  static const String sprinklerActive = 'AKTIF';
  static const String sprinklerInactive = 'NONAKTIF';

  // Chart Page
  static const String chartData = 'Grafik Sensor';
  static const String chartTemperature = 'Suhu';
  static const String chartTemperatureUnit = 'Grafik Suhu (°C)';
  static const String chartHumidity = 'Kelembapan Udara';
  static const String chartHumidityUnit = 'Grafik Kelembapan Udara (%)';
  static const String chartSoil = 'Kelembapan Tanah';
  static const String chartSoilUnit = 'Grafik Kelembapan Tanah (%)';
  static const String chartLight = 'Grafik Cahaya';
  static const String chartLightUnit = 'Grafik Cahaya (lux)';
  static const String average = 'Rata-rata';
  static const String maximum = 'Maksimum';
  static const String minimum = 'Minimum';

  // Settings Page
  static const String pageSettings = 'Pengaturan';
  static const String configRunning = 'Konfigurasi Berjalan';
  static const String configList = 'Daftar Konfigurasi';
  static const String addConfig = 'Tambah Konfigurasi';
  static const String stopConfig = 'Hentikan';
  static const String startConfig = 'Jalankan';
  static const String editConfig = 'Edit';
  static const String deleteConfig = 'Hapus';
  static const String dayOf = 'Hari ke';
  static const String targetDays = 'Target';
  static const String durationDays = 'Lama Hari';

  // Config Form
  static const String configName = 'Nama Konfigurasi';
  static const String lamp1DelayDays = 'Delay Lampu 1 (hari)';
  static const String lamp2DelayDays = 'Delay Lampu 2 (hari)';
  static const String wateringMode = 'Mode Penyiraman';
  static const String wateringModeTime = 'Berdasarkan Jadwal Waktu';
  static const String wateringModeSoil = 'Berdasarkan Sensor Tanah';
  static const String soilThreshold = 'Threshold Kelembapan Tanah (%)';
  static const String wateringDuration = 'Durasi Penyiraman (detik)';
  static const String wateringTimes = 'Jadwal Penyiraman';

  // History Page
  static const String pageHistory = 'History';
  static const String today = 'Hari Ini';
  static const String custom = 'Tanggal Tertentu';
  static const String configColumn = 'Konfigurasi';
  static const String dayColumn = 'Hari ke';
  static const String wateringColumn = 'Siram';

  // Common
  static const String loading = 'Memuat data...';
  static const String noData = 'Tidak ada data';
  static const String errorLoad = 'Gagal memuat data';
  static const String saved = 'Pengaturan berhasil disimpan!';
  static const String saveFailed = 'Gagal menyimpan pengaturan';
  static const String saveSettings = 'Simpan';
  static const String cancel = 'Batal';
  static const String confirm = 'Konfirmasi';
  static const String yes = 'Ya';
  static const String no = 'Tidak';
}
