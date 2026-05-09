import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Cerchio per icone con effetto aura (glow).
/// Usato per dare importanza alle icone nelle card o nei titoli.
class DndMysticIconCircle extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final double size;
  final bool showGlow;

  const DndMysticIconCircle({
    super.key,
    required this.icon,
    this.accentColor = AppColors.magicAccent,
    this.size = 40.0,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: showGlow ? [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ] : null,
      ),
      child: Center(
        child: Icon(
          icon,
          color: accentColor,
          size: size * 0.55,
        ),
      ),
    );
  }
}
