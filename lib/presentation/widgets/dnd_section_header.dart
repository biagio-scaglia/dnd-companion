import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Intestazione di sezione coerente con stile fantasy.
/// Evoluzione di DndSectionTitle con supporto per sottotitolo e stile più raffinato.
class DndSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color accentColor;
  final Widget? trailing;

  const DndSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.accentColor = AppColors.highlight,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Barra di accento verticale con gradiente e rombo
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 2,
                height: subtitle != null ? 36 : 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withOpacity(0.2)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              Transform.rotate(
                angle: 45 * 3.1415927 / 180,
                child: Container(
                  width: 6,
                  height: 6,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.h2.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
