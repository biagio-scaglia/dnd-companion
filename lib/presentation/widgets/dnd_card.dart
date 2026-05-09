import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

enum DndCardVariant { standard, featured, ghost }

/// Card base del design system D&D.
/// - standard: card normale con bordo sottile
/// - featured: card con glow accent, per elementi importanti
/// - ghost: sfondo trasparente, solo bordo
class DndCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;
  final BoxShadow? shadow;
  final Color? borderColor;
  final DndCardVariant variant;
  final Color? accentColor;
  final VoidCallback? onTap;

  const DndCard({
    super.key,
    required this.child,
    this.padding,
    this.gradientColors,
    this.shadow,
    this.borderColor,
    this.variant = DndCardVariant.standard,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? AppColors.magicAccent;

    Color? bgColor;
    List<Color>? gradient;
    Color border;
    List<BoxShadow> shadows;

    switch (variant) {
      case DndCardVariant.featured:
        bgColor = null;
        gradient = gradientColors ??
            [AppColors.surface, AppColors.surfaceSecondary.withValues(alpha: 0.6)];
        border = borderColor ?? accent.withValues(alpha: 0.25);
        shadows = [
          shadow ??
              BoxShadow(
                color: accent.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
        ];
        break;
      case DndCardVariant.ghost:
        bgColor = Colors.transparent;
        gradient = null;
        border = borderColor ?? AppColors.surfaceSecondary;
        shadows = [];
        break;
      case DndCardVariant.standard:
        bgColor = gradientColors == null ? AppColors.surface : null;
        gradient = gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).colors
            : null;
        border = borderColor ?? AppColors.surfaceSecondary;
        shadows = shadow != null
            ? [shadow!]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ];
    }

    final container = Container(
      padding: padding ?? AppSpacing.paddingAllM,
      decoration: BoxDecoration(
        color: gradient == null ? bgColor : null,
        gradient: gradient != null
            ? LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: AppRadius.lBorderRadius,
        border: Border.all(color: border, width: 1),
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    return container;
  }
}
