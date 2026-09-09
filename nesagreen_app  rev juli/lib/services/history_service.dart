import '../core/constants/firebase_paths.dart';
import '../core/utils/date_helper.dart';
import '../models/history_model.dart';
import 'firebase_service.dart';

class HistoryService {
  final FirebaseService _firebaseService;

  HistoryService({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  /// Ambil histori berdasarkan tanggal tertentu
  Future<List<HistoryModel>> getHistoryByDate(String dateKey) async {
    final snap =
        await _firebaseService.readOnce(FirebasePaths.historyByDate(dateKey));

    if (!snap.exists || snap.value == null) return [];

    final data = snap.value as Map<dynamic, dynamic>;
    final List<HistoryModel> result = [];

    data.forEach((hour, value) {
      if (value is Map) {
        result.add(HistoryModel.fromMap(
          date: dateKey,
          hour: hour.toString(),
          map: value,
        ));
      }
    });

    // Urutkan berdasarkan jam
    result.sort((a, b) => a.hour.compareTo(b.hour));
    return result;
  }

  /// Ambil histori hari ini
  Future<List<HistoryModel>> getTodayHistory() async {
    return getHistoryByDate(DateHelper.todayKey());
  }

  /// Ambil histori 7 hari terakhir
  Future<Map<String, List<HistoryModel>>> getWeekHistory() async {
    final Map<String, List<HistoryModel>> result = {};
    final keys = DateHelper.lastWeekKeys();

    for (final key in keys) {
      final data = await getHistoryByDate(key);
      if (data.isNotEmpty) {
        result[key] = data;
      }
    }

    return result;
  }
}
