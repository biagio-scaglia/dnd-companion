import 'dart:ui';
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
  final bool showGlow;
  final bool isGlass;
  final List<Color>? gradientBorderColors;

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
    this.showGlow = false,
    this.isGlass = false,
    this.gradientBorderColors,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? AppColors.magicAccent;

    Color? bgColor;
    List<Color>? gradient;
    Color border;
    List<BoxShadow> shadows = [];

    // Gestione Glow (da DndFantasyCard)
    if (showGlow) {
      shadows.add(
        BoxShadow(
          color: accent.withValues(alpha: 0.15),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 0),
        ),
      );
    }

    switch (variant) {
      case DndCardVariant.featured:
        bgColor = null;
        gradient = gradientColors ??
            [AppColors.surface, AppColors.surfaceSecondary.withValues(alpha: 0.6)];
        border = borderColor ?? accent.withValues(alpha: 0.25);
        shadows.add(
          shadow ??
              BoxShadow(
                color: accent.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
        );
        break;
      case DndCardVariant.ghost:
        bgColor = Colors.transparent;
        gradient = null;
        border = borderColor ?? AppColors.surfaceSecondary;
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
        shadows.add(
          shadow ??
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
        );
    }

    Widget content = Container(
      padding: padding ?? AppSpacing.paddingAllM,
      child: child,
    );

    // Gestione Glass (da DndFantasyCard)
    if (isGlass) {
      content = ClipRRect(
        borderRadius: AppRadius.lBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: content,
        ),
      );
    }

    final cardBgColor = bgColor ?? (isGlass ? AppColors.surface.withValues(alpha: 0.7) : AppColors.surface);

    final Widget card;
    if (onTap != null) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.lBorderRadius,
          boxShadow: shadows,
        ),
        child: Material(
          color: gradient == null ? cardBgColor : Colors.transparent,
          borderRadius: AppRadius.lBorderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.lBorderRadius,
            splashColor: (accentColor ?? AppColors.magicAccent).withValues(alpha: 0.15),
            highlightColor: (accentColor ?? AppColors.magicAccent).withValues(alpha: 0.05),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient != null
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: gradientBorderColors == null ? Border.all(color: border, width: 1) : null,
              ),
              child: content,
            ),
          ),
        ),
      );
    } else {
      card = Container(
        decoration: BoxDecoration(
          color: gradient == null ? cardBgColor : null,
          gradient: gradient != null
              ? LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: AppRadius.lBorderRadius,
          border: gradientBorderColors == null ? Border.all(color: border, width: 1) : null,
          boxShadow: shadows,
        ),
        child: content,
      );
    }

    // Gestione Bordo Gradiente (da DndFantasyCard)
    Widget result;
    if (gradientBorderColors != null) {
      result = Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientBorderColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.lBorderRadius,
          boxShadow: shadows,
        ),
        child: card,
      );
    } else {
      result = card;
    }

    return result;
  }
}
