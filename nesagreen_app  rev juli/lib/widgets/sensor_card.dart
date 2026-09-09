import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SensorCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color badgeColor;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const SensorCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.badgeColor,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.iconColor.withOpacity(0.06)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? widget.iconColor.withOpacity(0.15)
                    : AppColors.shadow,
                blurRadius: _hovered ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: _hovered
                  ? widget.iconColor.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (widget.onTap != null)
                      Text(
                        'Tap untuk lihat grafik',
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.iconColor.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (widget.onTap != null) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: widget.iconColor.withOpacity(0.5),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
