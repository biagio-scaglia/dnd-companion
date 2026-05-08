import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_radius.dart';

/// Chip/filtro riusabile per Compendio, tag note, badge personaggi.
class DndChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color accentColor;
  final IconData? icon;

  const DndChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.accentColor = AppColors.magicAccent,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: icon != null ? 10 : 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.15)
              : AppColors.surfaceSecondary,
          borderRadius: AppRadius.pillBorderRadius,
          border: Border.all(
            color: isSelected ? accentColor.withOpacity(0.5) : AppColors.surfaceSecondary,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? accentColor : AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label.toUpperCase(),
              style: AppTypography.label.copyWith(
                color: isSelected ? accentColor : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
