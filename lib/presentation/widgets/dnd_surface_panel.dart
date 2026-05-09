import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Pannello di base per raggruppare elementi.
/// Più leggero di una card, serve a strutturare la pagina.
class DndSurfacePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showBorder;

  const DndSurfacePanel({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.paddingAllM,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceSecondary.withValues(alpha: 0.3),
        borderRadius: AppRadius.mBorderRadius,
        border: showBorder ? Border.all(
          color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
          width: 1,
        ) : null,
      ),
      child: child,
    );
  }
}
