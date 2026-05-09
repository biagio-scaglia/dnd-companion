import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Card con estetica fantasy premium.
/// Supporta glow, bordi sfumati e un leggero effetto vetro (glassmorphism).
class DndFantasyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientBorderColors;
  final bool showGlow;
  final Color? glowColor;
  final bool isGlass;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const DndFantasyCard({
    super.key,
    required this.child,
    this.padding,
    this.gradientBorderColors,
    this.showGlow = false,
    this.glowColor,
    this.isGlass = false,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveGlowColor = glowColor ?? AppColors.magicAccent;
    final List<Color> borderGradient = gradientBorderColors ?? [
      AppColors.surfaceSecondary,
      AppColors.surfaceSecondary,
    ];

    final List<BoxShadow> shadows = [];
    if (showGlow) {
      shadows.add(
        BoxShadow(
          color: effectiveGlowColor.withValues(alpha: 0.15),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 0),
        ),
      );
    }
    shadows.add(
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    );

    Widget content = Container(
      padding: padding ?? AppSpacing.paddingAllM,
      child: child,
    );

    // Se è glass, applichiamo l'effetto sfocatura
    if (isGlass) {
      content = ClipRRect(
        borderRadius: AppRadius.lBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: content,
        ),
      );
    }

    final Widget card = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? (isGlass ? AppColors.surface.withValues(alpha: 0.7) : AppColors.surface),
        borderRadius: AppRadius.lBorderRadius,
        boxShadow: shadows,
      ),
      child: content,
    );

    // Se abbiamo un gradiente per il bordo, usiamo una tecnica a doppio container
    Widget result;
    if (gradientBorderColors != null) {
      result = Container(
        padding: const EdgeInsets.all(1.0), // Spessore del bordo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: borderGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.lBorderRadius,
        ),
        child: card,
      );
    } else {
      result = Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.surfaceSecondary, width: 1),
          borderRadius: AppRadius.lBorderRadius,
        ),
        child: card,
      );
    }

    // Se c'è un'azione di tap
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: result,
      );
    }

    return result;
  }
}
