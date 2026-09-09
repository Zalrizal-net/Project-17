import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/config_provider.dart';
import '../../providers/control_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/lamp_control_card.dart';

class ManualPage extends ConsumerWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lamp1     = ref.watch(lamp1NotifierProvider);
    final lamp2     = ref.watch(lamp2NotifierProvider);
    final sprinkler = ref.watch(sprinklerNotifierProvider);
    final sensorAsync = ref.watch(sensorStreamProvider);
    final activeConfig = ref.watch(activeConfigProvider);

    final activeConfigName = activeConfig.when(
      data: (c) => c.isRunning ? c.configName : null,
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.pageManual),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Warning banner jika ada config aktif ──────────────
            if (activeConfigName != null) ...[
              _buildWarningBanner(activeConfigName),
              const SizedBox(height: 12),
            ],

            // ── Kontrol Lampu ─────────────────────────────────────
            _sectionLabel('Kontrol Lampu'),
            const SizedBox(height: 6),
            LampControlCard(
              label: AppStrings.lamp1,
              isOn: lamp1.status,
              color: AppColors.lamp1Color,
              icon: Icons.wb_incandescent_rounded,
              onToggle: (v) {
                if (activeConfigName != null) {
                  _showAutoWarning(context, AppStrings.lamp1, activeConfigName, () {
                    ref.read(lamp1NotifierProvider.notifier).setStatus(v);
                  });
                } else {
                  ref.read(lamp1NotifierProvider.notifier).setStatus(v);
                }
              },
            ),
            const SizedBox(height: 8),
            LampControlCard(
              label: AppStrings.lamp2,
              isOn: lamp2.status,
              color: AppColors.lamp2Color,
              icon: Icons.wb_incandescent_outlined,
              onToggle: (v) {
                if (activeConfigName != null) {
                  _showAutoWarning(context, AppStrings.lamp2, activeConfigName, () {
                    ref.read(lamp2NotifierProvider.notifier).setStatus(v);
                  });
                } else {
                  ref.read(lamp2NotifierProvider.notifier).setStatus(v);
                }
              },
            ),
            const SizedBox(height: 16),

            // ── Penyiraman Manual ─────────────────────────────────
            _sectionLabel('Penyiraman Manual'),
            const SizedBox(height: 6),
            _buildSprinklerCard(context, ref, sprinkler.status, activeConfigName, sensorAsync),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
  );

  Widget _buildWarningBanner(String configName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.warning, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mode otomatis aktif — Konfigurasi: $configName\nPerubahan manual bersifat sementara.',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.warning,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprinklerCard(
    BuildContext context,
    WidgetRef ref,
    bool isOn,
    String? activeConfigName,
    AsyncValue sensorAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOn
            ? AppColors.humidity.withOpacity(0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOn
              ? AppColors.humidity.withOpacity(0.4)
              : AppColors.divider,
        ),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? AppColors.humidity.withOpacity(0.15)
                : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOn
                      ? AppColors.humidity.withOpacity(0.15)
                      : AppColors.divider.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.water_drop_rounded,
                    color: isOn ? AppColors.humidity : AppColors.inactive,
                    size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sprinkler / Pompa Air',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: isOn ? AppColors.humidity : AppColors.inactive,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isOn ? 'Sedang Menyiram' : 'Tidak Aktif',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isOn ? AppColors.humidity : AppColors.inactive,
                          ),
                        ),
                      ],
                    ),
                    // Tampilkan kelembapan tanah sebagai info tambahan
                    sensorAsync.when(
                      data: (sensor) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Kelembapan tanah: ${sensor.soil.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isOn,
                onChanged: (v) {
                  if (activeConfigName != null) {
                    _showAutoWarning(context, 'Sprinkler', activeConfigName, () {
                      ref.read(sprinklerNotifierProvider.notifier).setStatus(v);
                    });
                  } else {
                    ref.read(sprinklerNotifierProvider.notifier).setStatus(v);
                  }
                },
                activeColor: Colors.white,
                activeTrackColor: AppColors.humidity,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),
          // Tombol siram instan
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                void doWater() {
                  final notifier =
                      ref.read(sprinklerNotifierProvider.notifier);
                  notifier.setStatus(true);
                  // Auto-off setelah 30 detik (demo)
                  Future.delayed(const Duration(seconds: 30), () {
                    notifier.setStatus(false);
                  });
                }

                if (activeConfigName != null) {
                  _showAutoWarning(
                      context, 'Sprinkler', activeConfigName, doWater);
                } else {
                  doWater();
                }
              },
              icon: const Icon(Icons.water_drop_outlined, size: 16),
              label: const Text('Siram Sekarang (30 detik)',
                  style: TextStyle(fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.humidity,
                side: BorderSide(
                    color: AppColors.humidity.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAutoWarning(
    BuildContext context,
    String device,
    String configName,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: AppColors.warning, size: 20),
            const SizedBox(width: 8),
            const Text('Mode Otomatis Aktif',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Saat ini sedang dalam mode otomatis dengan konfigurasi:\n\n'
          '"$configName"\n\n'
          'Perubahan $device ini bersifat sementara dan dapat ditimpa oleh sistem.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Tetap Lanjutkan'),
          ),
        ],
      ),
    );
  }
}
