import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

class DndButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const DndButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.highlight,
            foregroundColor: foregroundColor ?? AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mBorderRadius),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.surfaceSecondary,
            foregroundColor: foregroundColor ?? AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.mBorderRadius,
              side: BorderSide(color: backgroundColor ?? AppColors.surfaceSecondary),
            ),
          );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, size: 18),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
