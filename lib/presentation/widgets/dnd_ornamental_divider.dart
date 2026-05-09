import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Un divisore con un piccolo rombo o runa al centro.
/// Perfetto per separare sezioni in modo elegante e fantasy.
class DndOrnamentalDivider extends StatelessWidget {
  final Color? color;
  final double thickness;
  final double space;

  const DndOrnamentalDivider({
    super.key,
    this.color,
    this.thickness = 1.0,
    this.space = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppColors.surfaceSecondary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: space / 2),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: thickness,
              color: effectiveColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 12),
          // Rombo centrale
          Transform.rotate(
            angle: 45 * 3.1415927 / 180, // 45 gradi
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: effectiveColor,
                border: Border.all(color: effectiveColor, width: 1),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: thickness,
              color: effectiveColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
