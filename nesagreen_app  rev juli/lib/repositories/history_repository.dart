import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryRepository {
  final HistoryService _historyService;

  HistoryRepository({HistoryService? historyService})
      : _historyService = historyService ?? HistoryService();

  Future<List<HistoryModel>> getHistoryByDate(String dateKey) =>
      _historyService.getHistoryByDate(dateKey);

  Future<List<HistoryModel>> getTodayHistory() =>
      _historyService.getTodayHistory();

  Future<Map<String, List<HistoryModel>>> getWeekHistory() =>
      _historyService.getWeekHistory();
}
