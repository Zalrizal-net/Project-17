import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatter.dart';
import '../../providers/config_provider.dart';
import '../../providers/control_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../widgets/active_config_card.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/sensor_card.dart';
import '../../widgets/status_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorAsync    = ref.watch(sensorStreamProvider);
    final lamp1State     = ref.watch(lamp1NotifierProvider);
    final lamp2State     = ref.watch(lamp2NotifierProvider);
    final sprinklerAsync = ref.watch(sprinklerStreamProvider);
    final activeConfig   = ref.watch(activeConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 10),

              // ── Status Koneksi ──────────────────────────────────
              const StatusBar(),
              const SizedBox(height: 12),

              // ── Konfigurasi Aktif ────────────────────────────────
              _sectionLabel(AppStrings.activeConfig),
              const SizedBox(height: 6),
              activeConfig.when(
                data: (config) => ActiveConfigCard(
                  config: config,
                  onStop: config.isRunning
                      ? () => _confirmStop(context, ref)
                      : null,
                ),
                loading: () => const _SkeletonCard(height: 120),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 14),

              // ── Status Lampu ─────────────────────────────────────
              _sectionLabel(AppStrings.lampStatus),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: _LampStatusBadge(
                    label: 'Lampu 1',
                    isOn: lamp1State.status,
                    color: AppColors.lamp1Color,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _LampStatusBadge(
                    label: 'Lampu 2',
                    isOn: lamp2State.status,
                    color: AppColors.lamp2Color,
                  )),
                ],
              ),
              const SizedBox(height: 8),

              // ── Status Sprinkler ─────────────────────────────────
              sprinklerAsync.when(
                data: (sp) => _SprinklerBadge(isActive: sp.status),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 14),

              // ── Sensor Realtime ──────────────────────────────────
              _sectionLabel(AppStrings.currentCondition),
              const SizedBox(height: 6),
              sensorAsync.when(
                data: (sensor) => Column(
                  children: [
                    SensorCard(
                      icon: Icons.thermostat_rounded,
                      iconColor: AppColors.temperature,
                      badgeColor: AppColors.temperature,
                      label: AppStrings.temperature,
                      value: Formatter.temperature(sensor.temperature),
                      onTap: () {
                        ref.read(chartScrollTargetProvider.notifier).state = 1;
                        ref.read(navigationIndexProvider.notifier).state = 2;
                      },
                    ),
                    SensorCard(
                      icon: Icons.water_drop_rounded,
                      iconColor: AppColors.humidity,
                      badgeColor: AppColors.humidity,
                      label: AppStrings.humidity,
                      value: Formatter.humidity(sensor.humidity),
                      onTap: () {
                        ref.read(chartScrollTargetProvider.notifier).state = 2;
                        ref.read(navigationIndexProvider.notifier).state = 2;
                      },
                    ),
                    SensorCard(
                      icon: Icons.grass_rounded,
                      iconColor: AppColors.soil,
                      badgeColor: AppColors.soil,
                      label: AppStrings.soil,
                      value: Formatter.humidity(sensor.soil),
                      onTap: () {
                        ref.read(chartScrollTargetProvider.notifier).state = 3;
                        ref.read(navigationIndexProvider.notifier).state = 2;
                      },
                    ),
                    SensorCard(
                      icon: Icons.wb_sunny_rounded,
                      iconColor: AppColors.light,
                      badgeColor: AppColors.light,
                      label: AppStrings.light,
                      value: Formatter.lightLux(sensor.light),
                      onTap: () {
                        ref.read(chartScrollTargetProvider.notifier).state = 4;
                        ref.read(navigationIndexProvider.notifier).state = 2;
                      },
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(AppStrings.errorLoad,
                      style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 14),

              // ── Akses Cepat ──────────────────────────────────────
              _sectionLabel(AppStrings.menu),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: MenuButton(
                    icon: Icons.show_chart_rounded,
                    label: AppStrings.viewChart,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: MenuButton(
                    icon: Icons.history_rounded,
                    label: AppStrings.history,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: MenuButton(
                    icon: Icons.touch_app_rounded,
                    label: AppStrings.manualMode,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: MenuButton(
                    icon: Icons.settings_rounded,
                    label: AppStrings.settings,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 4,
                  )),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
  );

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8, top: -8,
            child: Icon(Icons.eco_rounded, size: 70,
                color: Colors.white.withOpacity(0.15))),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.appName,
                  style: TextStyle(
                      color: Colors.white, fontSize: 22,
                      fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              SizedBox(height: 2),
              Text('IoT Monitoring & Control System',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmStop(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hentikan Konfigurasi?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text(
            'Konfigurasi yang sedang berjalan akan dihentikan. Data hari ini tetap tersimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(configNotifierProvider.notifier).stopConfig();
            },
            child: const Text('Hentikan'),
          ),
        ],
      ),
    );
  }
}

// ── Lamp Status Badge ──────────────────────────────────────────────────────────

class _LampStatusBadge extends StatelessWidget {
  final String label;
  final bool isOn;
  final Color color;
  const _LampStatusBadge({required this.label, required this.isOn, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isOn ? color.withOpacity(0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOn ? color.withOpacity(0.4) : AppColors.divider,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.wb_incandescent_rounded,
              size: 16, color: isOn ? color : AppColors.inactive),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                Text(
                  isOn ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isOn ? color : AppColors.inactive,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sprinkler Badge ────────────────────────────────────────────────────────────

class _SprinklerBadge extends StatelessWidget {
  final bool isActive;
  const _SprinklerBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.humidity : AppColors.inactive;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.humidity.withOpacity(0.07)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.humidity.withOpacity(0.4)
              : AppColors.divider,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.water_drop_rounded, size: 16, color: color),
          const SizedBox(width: 8),
          Text(AppStrings.sprinklerStatus2,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? 'Sedang Menyiram' : 'Tidak Aktif',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Skeleton Loading ───────────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  final double height;
  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.divider.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
