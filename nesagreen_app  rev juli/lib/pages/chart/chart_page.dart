import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/history_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/chart_widget.dart';
import '../../widgets/custom_appbar.dart';

class ChartPage extends ConsumerStatefulWidget {
  const ChartPage({super.key});

  @override
  ConsumerState<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends ConsumerState<ChartPage> {
  final _scrollController = ScrollController();
  final _tempKey  = GlobalKey();
  final _humidKey = GlobalKey();
  final _soilKey  = GlobalKey();
  final _lightKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTarget(int target) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalKey? key;
      if (target == 1) key = _tempKey;
      if (target == 2) key = _humidKey;
      if (target == 3) key = _soilKey;
      if (target == 4) key = _lightKey;
      if (key?.currentContext == null) return;
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      ref.read(chartScrollTargetProvider.notifier).state = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollTarget = ref.watch(chartScrollTargetProvider);
    if (scrollTarget != 0) _scrollToTarget(scrollTarget);

    final historyAsync = ref.watch(chartHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.chartData),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 64, color: AppColors.inactive),
                  SizedBox(height: 12),
                  Text(AppStrings.noData,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Container(key: _tempKey,
                child: ChartWidget(
                  title: AppStrings.chartTemperature,
                  icon: Icons.thermostat_rounded,
                  color: AppColors.chartTemperature,
                  data: history,
                  valueSelector: (h) => h.temperature,
                  unit: '°C', minY: 0, maxY: 50,
                  autoScrollToNow: true,
                ),
              ),
              Container(key: _humidKey,
                child: ChartWidget(
                  title: AppStrings.chartHumidity,
                  icon: Icons.water_drop_rounded,
                  color: AppColors.chartHumidity,
                  data: history,
                  valueSelector: (h) => h.humidity,
                  unit: '%', minY: 0, maxY: 100,
                  autoScrollToNow: true,
                ),
              ),
              Container(key: _soilKey,
                child: ChartWidget(
                  title: AppStrings.chartSoil,
                  icon: Icons.grass_rounded,
                  color: AppColors.chartSoil,
                  data: history,
                  valueSelector: (h) => h.soil,
                  unit: '%', minY: 0, maxY: 100,
                  autoScrollToNow: true,
                ),
              ),
              Container(key: _lightKey,
                child: ChartWidget(
                  title: AppStrings.chartLight,
                  icon: Icons.wb_sunny_rounded,
                  color: AppColors.chartLight,
                  data: history,
                  valueSelector: (h) => h.light,
                  unit: 'lux', minY: 0, maxY: 1000,
                  autoScrollToNow: true,
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Text(AppStrings.errorLoad,
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}
