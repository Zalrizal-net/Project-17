import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/date_helper.dart';
import '../models/history_model.dart';
import '../repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

// Filter: hapus 'week', hanya today dan custom
enum HistoryFilter { today, custom }

final historyFilterProvider = StateProvider<HistoryFilter>((ref) {
  return HistoryFilter.today;
});

final historyCustomDateProvider = StateProvider<String>((ref) {
  return DateHelper.todayKey();
});

final historyDataProvider =
    FutureProvider.autoDispose<List<HistoryModel>>((ref) async {
  final repo       = ref.watch(historyRepositoryProvider);
  final filter     = ref.watch(historyFilterProvider);
  final customDate = ref.watch(historyCustomDateProvider);

  switch (filter) {
    case HistoryFilter.today:
      return repo.getTodayHistory();
    case HistoryFilter.custom:
      return repo.getHistoryByDate(customDate);
  }
});

// Provider history untuk grafik (hari ini)
final chartHistoryProvider =
    FutureProvider.autoDispose<List<HistoryModel>>((ref) async {
  final repo = ref.watch(historyRepositoryProvider);
  return repo.getTodayHistory();
});
