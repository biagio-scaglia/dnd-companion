import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class DndCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;
  final BoxShadow? shadow;
  final Color? borderColor;

  const DndCard({
    super.key,
    required this.child,
    this.padding,
    this.gradientColors,
    this.shadow,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.paddingAllM,
      decoration: BoxDecoration(
        color: gradientColors == null ? AppColors.surface : null,
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: AppRadius.lBorderRadius,
        border: Border.all(
          color: borderColor ?? AppColors.surfaceSecondary,
          width: 1,
        ),
        boxShadow: shadow != null ? [shadow!] : [],
      ),
      child: child,
    );
  }
}
