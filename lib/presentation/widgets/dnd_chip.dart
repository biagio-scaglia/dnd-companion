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
  final String? imagePath;

  const DndChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.accentColor = AppColors.magicAccent,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: (icon != null || imagePath != null) ? 10 : 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.15)
              : AppColors.surfaceSecondary,
          borderRadius: AppRadius.pillBorderRadius,
          border: Border.all(
            color: isSelected ? accentColor.withValues(alpha: 0.5) : AppColors.surfaceSecondary,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                width: 14,
                height: 14,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 5),
            ] else if (icon != null) ...[
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
