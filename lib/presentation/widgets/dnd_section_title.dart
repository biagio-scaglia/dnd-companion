import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Titolo di sezione con linea accent a sinistra.
/// Usare ovunque al posto di Text inline per i titoli di sezione.
class DndSectionTitle extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Widget? trailing;

  const DndSectionTitle({
    super.key,
    required this.title,
    this.accentColor = AppColors.highlight,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTypography.h2,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
