import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/active_config_model.dart';
import '../../models/planting_config_model.dart';
import '../../providers/config_provider.dart';
import '../../widgets/active_config_card.dart';
import '../../widgets/custom_appbar.dart';
import 'add_config_sheet.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeConfig = ref.watch(activeConfigProvider);
    final configsAsync = ref.watch(plantingConfigsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.pageSettings),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.extended(
          onPressed: () => _openAddConfigSheet(context, ref, null),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text(AppStrings.addConfig,
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Konfigurasi Aktif ─────────────────────────────────
            _sectionLabel(AppStrings.configRunning),
            const SizedBox(height: 6),
            activeConfig.when(
              data: (config) => ActiveConfigCard(
                config: config,
                onStop: config.isRunning
                    ? () => _confirmStop(context, ref)
                    : null,
              ),
              loading: () => const _LoadingCard(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),

            // ── Daftar Konfigurasi ────────────────────────────────
            _sectionLabel(AppStrings.configList),
            const SizedBox(height: 6),
            configsAsync.when(
              data: (configs) {
                if (configs.isEmpty) {
                  return _buildEmpty();
                }
                return Column(
                  children: configs
                      .map((cfg) => _ConfigItem(
                            config: cfg,
                            activeConfig: activeConfig.value,
                            onEdit: () => _openAddConfigSheet(context, ref, cfg),
                            onDelete: () => _confirmDelete(context, ref, cfg),
                            onStart: () => _confirmStart(context, ref, cfg),
                            onStop: () => _confirmStop(context, ref),
                          ))
                      .toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (e, _) => Center(
                child: Text(AppStrings.errorLoad,
                    style: const TextStyle(color: AppColors.error)),
              ),
            ),
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

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        children: [
          Icon(Icons.eco_outlined, size: 48, color: AppColors.inactive),
          SizedBox(height: 12),
          Text('Belum ada konfigurasi',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text('Tekan tombol + untuk menambahkan konfigurasi penanaman baru',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _openAddConfigSheet(
      BuildContext context, WidgetRef ref, PlantingConfigModel? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: AddConfigSheet(existing: existing),
      ),
    );
  }

  void _confirmStart(
      BuildContext context, WidgetRef ref, PlantingConfigModel cfg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Mulai Konfigurasi?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(
          'Konfigurasi "${cfg.name}" akan dijalankan mulai hari ini.\n'
          'Target: ${cfg.durationDays} hari.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(configNotifierProvider.notifier).startConfig(cfg);
              if (ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text('Konfigurasi "${cfg.name}" dimulai! 🌱'),
                    backgroundColor: AppColors.active,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _confirmStop(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hentikan Konfigurasi?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text(
            'Konfigurasi yang sedang berjalan akan dihentikan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(configNotifierProvider.notifier).stopConfig();
            },
            child: const Text('Hentikan'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, PlantingConfigModel cfg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Konfigurasi?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text('Konfigurasi "${cfg.name}" akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(configNotifierProvider.notifier)
                  .deleteConfig(cfg.id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// ─── Config Item Card ─────────────────────────────────────────────────────────

class _ConfigItem extends StatelessWidget {
  final PlantingConfigModel config;
  final ActiveConfigModel? activeConfig;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const _ConfigItem({
    required this.config,
    required this.activeConfig,
    required this.onEdit,
    required this.onDelete,
    required this.onStart,
    required this.onStop,
  });

  bool get isRunning =>
      activeConfig?.isRunning == true &&
      activeConfig?.configId == config.id;

  @override
  Widget build(BuildContext context) {
    final isRunningThis = isRunning;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isRunningThis
            ? AppColors.primaryContainer
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRunningThis ? AppColors.primary : AppColors.divider,
          width: isRunningThis ? 1.5 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isRunningThis
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.eco_rounded,
                      color: AppColors.primary, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(config.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                          ),
                          if (isRunningThis)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('BERJALAN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${config.durationDays} hari  •  '
                        'Lampu: L1≥hari${config.lamp1DelayDays}, L2≥hari${config.lamp2DelayDays}  •  '
                        'Siram: ${config.wateringMode == WateringMode.soil ? "Sensor tanah" : "${config.wateringTimes.length}x/hari"}',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                // Tombol Edit
                _ActionBtn(
                  icon: Icons.edit_rounded,
                  label: 'Edit',
                  color: AppColors.info,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                // Tombol Hapus
                _ActionBtn(
                  icon: Icons.delete_outline_rounded,
                  label: 'Hapus',
                  color: AppColors.error,
                  onTap: onDelete,
                ),
                const Spacer(),
                // Tombol Start/Stop
                isRunningThis
                    ? _ActionBtn(
                        icon: Icons.stop_circle_rounded,
                        label: 'Hentikan',
                        color: AppColors.error,
                        filled: true,
                        onTap: onStop,
                      )
                    : _ActionBtn(
                        icon: Icons.play_circle_rounded,
                        label: 'Jalankan',
                        color: AppColors.primary,
                        filled: true,
                        onTap: onStart,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: filled ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: filled ? Colors.white : color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: filled ? Colors.white : color)),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.divider.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
