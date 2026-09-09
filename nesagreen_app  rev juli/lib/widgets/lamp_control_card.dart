import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Card untuk menampilkan dan mengontrol Lampu 1 atau Lampu 2
class LampControlCard extends StatelessWidget {
  final String label;       // "Lampu 1" atau "Lampu 2"
  final bool isOn;          // status lampu
  final Color color;        // warna indikator
  final IconData icon;      // ikon lampu
  final ValueChanged<bool> onToggle;
  final bool isEnabled;     // false jika ada peringatan mode auto

  const LampControlCard({
    super.key,
    required this.label,
    required this.isOn,
    required this.color,
    required this.icon,
    required this.onToggle,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isOn ? color.withOpacity(0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOn ? color.withOpacity(0.4) : AppColors.divider,
          width: isOn ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isOn ? color.withOpacity(0.15) : AppColors.shadow,
            blurRadius: isOn ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isOn ? color.withOpacity(0.15) : AppColors.divider.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isOn ? color : AppColors.inactive,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOn ? color : AppColors.inactive,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isOn ? 'MENYALA' : 'MATI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isOn ? color : AppColors.inactive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: isOn,
            onChanged: isEnabled ? onToggle : null,
            activeColor: Colors.white,
            activeTrackColor: color,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
