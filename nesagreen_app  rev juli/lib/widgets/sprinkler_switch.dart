import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class SprinklerSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SprinklerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: value
                ? AppColors.active.withOpacity(0.15)
                : AppColors.inactive.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.water_drop_rounded,
            color: value ? AppColors.active : AppColors.inactive,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.sprinklerStatus,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            Text(
              value ? AppStrings.sprinklerActive : AppStrings.sprinklerInactive,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: value ? AppColors.active : AppColors.inactive,
              ),
            ),
          ],
        ),
        const Spacer(),
        // FIX: thumb putih supaya terlihat jelas di semua kondisi
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppColors.primaryLight,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
