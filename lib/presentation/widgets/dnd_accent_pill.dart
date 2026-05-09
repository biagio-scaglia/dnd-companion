import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Chip/Pillola con accenti magici.
/// Usata per categorie, rarità o stati.
class DndAccentPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color accentColor;
  final bool isFilled;

  const DndAccentPill({
    super.key,
    required this.label,
    this.icon,
    this.accentColor = AppColors.highlight,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFilled ? accentColor.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: isFilled ? [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: accentColor, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: accentColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
