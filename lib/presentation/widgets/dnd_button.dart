import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

enum DndButtonVariant { primary, secondary, ghost, danger }

/// Bottone base del design system D&D.
/// - primary: sfondo highlight (gold), per CTA principali
/// - secondary: sfondo surface, per azioni secondarie
/// - ghost: solo bordo trasparente, per azioni terziarie
/// - danger: rosso, per azioni distruttive
class DndButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final DndButtonVariant variant;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isSmall;

  const DndButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = DndButtonVariant.primary,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isSmall = false,

    // Legacy compatibility
    bool isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? side;

    switch (variant) {
      case DndButtonVariant.secondary:
        bg = backgroundColor ?? AppColors.surfaceSecondary;
        fg = foregroundColor ?? AppColors.textPrimary;
        side = null;
        break;
      case DndButtonVariant.ghost:
        bg = Colors.transparent;
        fg = foregroundColor ?? AppColors.textPrimary;
        side = BorderSide(color: foregroundColor ?? AppColors.surfaceSecondary);
        break;
      case DndButtonVariant.danger:
        bg = AppColors.danger.withOpacity(0.15);
        fg = AppColors.danger;
        side = const BorderSide(color: AppColors.danger, width: 1);
        break;
      case DndButtonVariant.primary:
        bg = backgroundColor ?? AppColors.highlight;
        fg = foregroundColor ?? AppColors.background;
        side = null;
    }

    final textStyle = GoogleFonts.cinzel(
      fontWeight: FontWeight.bold,
      fontSize: isSmall ? 11 : 13,
      letterSpacing: 0.5,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: AppRadius.mBorderRadius,
      side: side ?? BorderSide.none,
    );

    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    final style = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      textStyle: textStyle,
      shape: shape,
      padding: padding,
      elevation: 0,
    );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, size: isSmall ? 14 : 18),
        label: Text(text, style: textStyle),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text, style: textStyle),
    );
  }
}
