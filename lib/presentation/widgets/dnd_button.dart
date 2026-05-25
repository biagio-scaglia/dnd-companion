import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

enum DndButtonVariant { primary, secondary, ghost, danger }

/// Bottone base del design system D&D.
/// - primary: sfondo highlight (gold), per CTA principali
/// - secondary: sfondo surface, per azioni secondarie
/// - ghost: solo bordo trasparente, per azioni terziarie
/// - danger: rosso, per azioni distruttive
class DndButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final DndButtonVariant variant;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isSmall;
  final bool enabled;

  const DndButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = DndButtonVariant.primary,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isSmall = false,
    this.enabled = true,
  });

  @override
  State<DndButton> createState() => _DndButtonState();
}

class _DndButtonState extends State<DndButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? side;

    if (!_isEnabled) {
      bg = AppColors.surfaceSecondary.withValues(alpha: 0.5);
      fg = AppColors.textMuted;
      side = null;
    } else {
      switch (widget.variant) {
        case DndButtonVariant.secondary:
          bg = widget.backgroundColor ?? AppColors.surfaceSecondary;
          fg = widget.foregroundColor ?? AppColors.textPrimary;
          side = null;
          break;
        case DndButtonVariant.ghost:
          bg = Colors.transparent;
          fg = widget.foregroundColor ?? AppColors.textPrimary;
          side = BorderSide(color: widget.foregroundColor ?? AppColors.surfaceSecondary);
          break;
        case DndButtonVariant.danger:
          bg = AppColors.danger.withValues(alpha: 0.15);
          fg = AppColors.danger;
          side = const BorderSide(color: AppColors.danger, width: 1);
          break;
        case DndButtonVariant.primary:
          bg = widget.backgroundColor ?? AppColors.highlight;
          fg = widget.foregroundColor ?? AppColors.background;
          side = null;
      }
    }

    final textStyle = TextStyle(
      fontFamily: 'Cinzel',
      fontWeight: FontWeight.bold,
      fontSize: widget.isSmall ? 11 : 13,
      letterSpacing: 0.5,
      color: fg,
    );

    final padding = widget.isSmall
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    return AnimatedScale(
      scale: (_isEnabled && _isPressed) ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      child: Material(
        color: bg,
        borderRadius: AppRadius.mBorderRadius,
        child: InkWell(
          onTap: _isEnabled ? widget.onPressed : null,
          onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: _isEnabled ? () => setState(() => _isPressed = false) : null,
          borderRadius: AppRadius.mBorderRadius,
          highlightColor: fg.withValues(alpha: 0.1),
          splashColor: fg.withValues(alpha: 0.2),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: AppRadius.mBorderRadius,
              border: side != null ? Border.fromBorderSide(side) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: fg, size: widget.isSmall ? 14 : 18),
                  const SizedBox(width: 8),
                ],
                Text(widget.text, style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
