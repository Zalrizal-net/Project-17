import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/formatter.dart';
import '../models/history_model.dart';

class ChartWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<HistoryModel> data;
  final double Function(HistoryModel) valueSelector;
  final String unit;
  final double minY;
  final double maxY;
  final bool autoScrollToNow; // scroll otomatis ke jam sekarang

  const ChartWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.data,
    required this.valueSelector,
    required this.unit,
    required this.minY,
    required this.maxY,
    this.autoScrollToNow = false,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  final ScrollController _scrollController = ScrollController();

  // Lebar per titik data (px) — cukup lebar agar semua label jam tampil
  static const double _pointWidth = 52.0;

  @override
  void initState() {
    super.initState();
    if (widget.autoScrollToNow && widget.data.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentHour());
    }
  }

  @override
  void didUpdateWidget(ChartWidget old) {
    super.didUpdateWidget(old);
    if (widget.autoScrollToNow && widget.data.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentHour());
    }
  }

  void _scrollToCurrentHour() {
    if (!_scrollController.hasClients) return;
    final currentHour = DateTime.now().hour;
    // Cari index data yang paling dekat jam sekarang
    int targetIdx = 0;
    for (int i = 0; i < widget.data.length; i++) {
      final h = int.tryParse(widget.data[i].hour.split(':')[0]) ?? 0;
      if (h <= currentHour) targetIdx = i;
    }
    // Scroll ke posisi jam sekarang, center jika mungkin
    final totalWidth   = widget.data.length * _pointWidth;
    final viewWidth    = _scrollController.position.viewportDimension;
    final targetOffset = (targetIdx * _pointWidth) - (viewWidth / 2);
    final maxOffset    = totalWidth - viewWidth;
    final clampedOffset = targetOffset.clamp(0.0, maxOffset > 0 ? maxOffset : 0.0);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return _buildEmpty();

    final spots = widget.data.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), widget.valueSelector(e.value)))
        .toList();

    final values = widget.data.map(widget.valueSelector).toList();
    final avg    = values.reduce((a, b) => a + b) / values.length;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);

    // Lebar total chart = jumlah titik × lebar per titik
    final chartWidth = widget.data.length * _pointWidth;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Row(
            children: [
              Icon(widget.icon, color: widget.color, size: 24),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Tombol scroll ke sekarang
              if (widget.autoScrollToNow)
                GestureDetector(
                  onTap: _scrollToCurrentHour,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: widget.color),
                        const SizedBox(width: 4),
                        Text(
                          'Sekarang',
                          style: TextStyle(fontSize: 10, color: widget.color, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Chart dengan horizontal scroll ──────────────────
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Sumbu Y tetap (tidak ikut scroll)
                SizedBox(
                  width: 36,
                  child: LineChart(
                    LineChartData(
                      minY: widget.minY,
                      maxY: widget.maxY,
                      gridData:    const FlGridData(show: false),
                      borderData:  FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [FlSpot(0, widget.minY), FlSpot(0, widget.maxY)],
                          color: Colors.transparent,
                        )
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            interval: (widget.maxY - widget.minY) / 4,
                            getTitlesWidget: (value, meta) => Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles:const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),

                // Chart area dengan scroll horizontal
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            minY: widget.minY,
                            maxY: widget.maxY,
                            clipData: const FlClipData.all(),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: (widget.maxY - widget.minY) / 4,
                              verticalInterval: 1,
                              getDrawingHorizontalLine: (_) =>
                                  FlLine(color: AppColors.divider, strokeWidth: 1),
                              getDrawingVerticalLine: (_) =>
                                  FlLine(color: AppColors.divider.withOpacity(0.5), strokeWidth: 0.5),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles:    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  interval: 1, // setiap titik tampil label
                                  getTitlesWidget: (value, meta) {
                                    final idx = value.toInt();
                                    if (idx < 0 || idx >= widget.data.length) {
                                      return const SizedBox();
                                    }
                                    // Highlight jam sekarang
                                    final currentHour = DateTime.now().hour;
                                    final dataHour = int.tryParse(
                                        widget.data[idx].hour.split(':')[0]) ?? -1;
                                    final isNow = dataHour == currentHour;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        widget.data[idx].hour,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                                          color: isNow ? widget.color : AppColors.textSecondary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: widget.color,
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, pct, bar, i) {
                                    final dataHour = int.tryParse(
                                        widget.data[i].hour.split(':')[0]) ?? -1;
                                    final isNow = dataHour == DateTime.now().hour;
                                    return FlDotCirclePainter(
                                      radius: isNow ? 5 : 3,
                                      color: isNow ? widget.color : widget.color,
                                      strokeWidth: isNow ? 2.5 : 1.5,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.color.withOpacity(0.3),
                                      widget.color.withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Statistik ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(Icons.bar_chart_rounded,         AppStrings.average,  '${Formatter.decimal1(avg)} ${widget.unit}',    AppColors.warning),
              _buildStat(Icons.arrow_circle_up_rounded,   AppStrings.maximum,  '${Formatter.decimal1(maxVal)} ${widget.unit}', widget.color),
              _buildStat(Icons.arrow_circle_down_rounded, AppStrings.minimum,  '${Formatter.decimal1(minVal)} ${widget.unit}', AppColors.info),
            ],
          ),

          // ── Legend ───────────────────────────────────────────
          const SizedBox(height: 12),
          Row(
            children: [
              Container(width: 16, height: 3, color: widget.color),
              const SizedBox(width: 6),
              Icon(Icons.circle, size: 8, color: widget.color),
              const SizedBox(width: 4),
              Text(
                '${widget.title} (${widget.unit})',
                style: TextStyle(fontSize: 11, color: widget.color, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '← geser untuk lihat semua →',
                style: TextStyle(fontSize: 9, color: AppColors.textSecondary.withOpacity(0.6), fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildEmpty() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(widget.icon, color: widget.color.withOpacity(0.4), size: 40),
            const SizedBox(height: 8),
            const Text(AppStrings.noData, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
