import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/formatter.dart';
import '../../models/history_model.dart';
import '../../providers/history_provider.dart';
import '../../widgets/chart_widget.dart';
import '../../widgets/custom_appbar.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter       = ref.watch(historyFilterProvider);
    final customDate   = ref.watch(historyCustomDateProvider);
    final historyAsync = ref.watch(historyDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.pageHistory),
      body: Column(
        children: [
          // ── Filter Tanggal ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: _buildFilter(context, ref, filter, customDate),
          ),

          // ── Sub-tab: Tabel | Grafik ─────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.primary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(text: '📋  Tabel Data'),
                Tab(text: '📈  Grafik'),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // ── Konten ─────────────────────────────────────────
          Expanded(
            child: historyAsync.when(
              data: (history) => TabBarView(
                controller: _tabController,
                children: [
                  _buildTableView(history),
                  _buildChartView(history),
                ],
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(
                child: Text(AppStrings.errorLoad,
                    style: const TextStyle(color: AppColors.error)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter ─────────────────────────────────────────────────
  Widget _buildFilter(
    BuildContext context,
    WidgetRef ref,
    HistoryFilter filter,
    String customDate,
  ) {
    return Row(
      children: [
        Expanded(
          child: _FilterButton(
            label: AppStrings.today,
            icon: Icons.today_rounded,
            isActive: filter == HistoryFilter.today,
            onTap: () =>
                ref.read(historyFilterProvider.notifier).state = HistoryFilter.today,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FilterButton(
            label: filter == HistoryFilter.custom
                ? _shortDate(customDate)
                : 'Pilih Tanggal',
            icon: Icons.calendar_month_rounded,
            isActive: filter == HistoryFilter.custom,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(
                        primary: AppColors.primary),
                  ),
                  child: child!,
                ),
              );
              if (date != null) {
                ref.read(historyCustomDateProvider.notifier).state =
                    DateHelper.toDateKey(date);
                ref.read(historyFilterProvider.notifier).state =
                    HistoryFilter.custom;
              }
            },
          ),
        ),
      ],
    );
  }

  // ── Tabel ──────────────────────────────────────────────────
  Widget _buildTableView(List<HistoryModel> history) {
    if (history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: AppColors.inactive),
            SizedBox(height: 12),
            Text(AppStrings.noData,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _buildItem(history[i]),
        ),
      ),
    );
  }

  Widget _buildItem(HistoryModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Jam
          Column(
            children: [
              Text(item.hour,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              if (item.dayNumber > 0)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Hari ${item.dayNumber}',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w500)),
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 1, height: 60,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama konfigurasi (jika ada)
                if (item.configName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.eco_rounded,
                            color: Colors.white54, size: 10),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(item.configName,
                              style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (item.wateringCount > 0) ...[
                          const Icon(Icons.water_drop_rounded,
                              color: Colors.white54, size: 10),
                          const SizedBox(width: 2),
                          Text('${item.wateringCount}x siram',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 10)),
                        ],
                      ],
                    ),
                  ),
                // Data sensor
                _dataRow(Icons.thermostat_rounded, AppColors.chartTemperature,
                    'Suhu', Formatter.temperature(item.temperature)),
                const SizedBox(height: 2),
                _dataRow(Icons.water_drop_rounded, AppColors.chartHumidity,
                    'Udara', Formatter.humidity(item.humidity)),
                const SizedBox(height: 2),
                _dataRow(Icons.grass_rounded, AppColors.chartSoil,
                    'Tanah', Formatter.humidity(item.soil)),
                const SizedBox(height: 2),
                _dataRow(Icons.wb_sunny_rounded, AppColors.chartLight,
                    'Cahaya', Formatter.lightLuxLower(item.light)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 10, color: color.withOpacity(0.8)),
        const SizedBox(width: 3),
        SizedBox(
            width: 44,
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 10))),
        const Text(': ', style: TextStyle(color: Colors.white70, fontSize: 10)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── Grafik ─────────────────────────────────────────────────
  Widget _buildChartView(List<HistoryModel> history) {
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ChartWidget(
          title: AppStrings.chartTemperature,
          icon: Icons.thermostat_rounded,
          color: AppColors.chartTemperature,
          data: history,
          valueSelector: (h) => h.temperature,
          unit: '°C', minY: 0, maxY: 50,
        ),
        ChartWidget(
          title: AppStrings.chartHumidity,
          icon: Icons.water_drop_rounded,
          color: AppColors.chartHumidity,
          data: history,
          valueSelector: (h) => h.humidity,
          unit: '%', minY: 0, maxY: 100,
        ),
        ChartWidget(
          title: AppStrings.chartSoil,
          icon: Icons.grass_rounded,
          color: AppColors.chartSoil,
          data: history,
          valueSelector: (h) => h.soil,
          unit: '%', minY: 0, maxY: 100,
        ),
        ChartWidget(
          title: AppStrings.chartLight,
          icon: Icons.wb_sunny_rounded,
          color: AppColors.chartLight,
          data: history,
          valueSelector: (h) => h.light,
          unit: 'lux', minY: 0, maxY: 1000,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _shortDate(String dateKey) {
    final parts = dateKey.split('-');
    if (parts.length != 3) return dateKey;
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final m = int.tryParse(parts[1]) ?? 0;
    return '${parts[2]} ${months[m]}';
  }
}

// ── Filter Button ─────────────────────────────────────────────

class _FilterButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterButton({
    required this.label, required this.icon,
    required this.isActive, required this.onTap,
  });
  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary
                : _hovered ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isActive ? AppColors.primary : AppColors.divider,
            ),
            boxShadow: widget.isActive
                ? [BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 16,
                  color: widget.isActive ? Colors.white : AppColors.primary),
              const SizedBox(width: 6),
              Text(widget.label,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: widget.isActive ? Colors.white : AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
