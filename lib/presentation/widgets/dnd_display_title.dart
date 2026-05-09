import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Titolo con elementi decorativi ai lati.
/// Perfetto per dare enfasi ai titoli di sezione senza cambiare font.
class DndDisplayTitle extends StatelessWidget {
  final String title;
  final Color? color;
  final bool isCenter;

  const DndDisplayTitle({
    super.key,
    required this.title,
    this.color,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppColors.highlight;

    final Widget textWidget = Text(
      title.toUpperCase(),
      style: AppTypography.label.copyWith(
        color: effectiveColor,
        letterSpacing: 2.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final Widget ornament = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 1,
          color: effectiveColor.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: effectiveColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );

    final Widget ornamentReversed = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: effectiveColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 20,
          height: 1,
          color: effectiveColor.withOpacity(0.5),
        ),
      ],
    );

    if (isCenter) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ornament,
          const SizedBox(width: 12),
          Flexible(child: textWidget),
          const SizedBox(width: 12),
          ornamentReversed,
        ],
      );
    }

    return Row(
      children: [
        textWidget,
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: effectiveColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
