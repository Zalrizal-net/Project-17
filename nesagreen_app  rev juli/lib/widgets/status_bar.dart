import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/connectivity_provider.dart';

class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userOnline   = ref.watch(userOnlineProvider);
    final deviceStatus = ref.watch(deviceStatusProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            userOnline.when(
              data: (online) => _Chip(
                icon: online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                label: online ? 'Online' : 'Anda Offline',
                color: online ? AppColors.active : AppColors.error,
              ),
              loading: () => const _Chip(icon: Icons.wifi_rounded, label: 'Memeriksa...', color: AppColors.inactive),
              error: (_, __) => const _Chip(icon: Icons.wifi_off_rounded, label: 'Offline', color: AppColors.error),
            ),
            const SizedBox(width: 6),
            deviceStatus.when(
              data: (s) => _Chip(
                icon: Icons.memory_rounded,
                label: s.isOnline ? 'ESP32 Online' : 'ESP32 Offline',
                color: s.isOnline ? AppColors.active : AppColors.error,
              ),
              loading: () => const _Chip(icon: Icons.memory_rounded, label: 'ESP32...', color: AppColors.inactive),
              error: (_, __) => const _Chip(icon: Icons.memory_rounded, label: 'ESP32 Offline', color: AppColors.error),
            ),
          ],
        ),
        // Banner offline ESP32
        deviceStatus.when(
          data: (s) {
            if (s.isOnline) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      s.lastSeen == 0
                          ? 'ESP32 belum pernah terhubung'
                          : 'ESP32 offline • Terakhir online: ${_fmt(s.lastSeen)}',
                      style: const TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error:   (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _fmt(int ts) {
    final dt  = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    final now = DateTime.now();
    final time = '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) return 'Hari ini $time';
    final yst = now.subtract(const Duration(days: 1));
    if (dt.day == yst.day && dt.month == yst.month) return 'Kemarin $time';
    const m = ['','Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return '${dt.day} ${m[dt.month]} $time';
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
