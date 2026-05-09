import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../presentation/widgets/dnd_fantasy_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../../../presentation/widgets/dnd_accent_pill.dart';
import '../../domain/models/compendium_item.dart';

class CompendiumItemCard extends StatelessWidget {
  final CompendiumItem item;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const CompendiumItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    IconData typeIcon;
    Color typeColor;

    switch (item.type) {
      case CompendiumItemType.monster:
        typeIcon = Icons.pest_control_rounded;
        typeColor = AppColors.danger;
        break;
      case CompendiumItemType.spell:
        typeIcon = Icons.auto_awesome_rounded;
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.item:
        typeIcon = Icons.shield_rounded;
        typeColor = AppColors.highlight;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DndFantasyCard(
        showGlow: item.isFavorite,
        glowColor: AppColors.danger,
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DndMysticIconCircle(
                  icon: typeIcon,
                  accentColor: typeColor,
                  size: 44,
                  showGlow: false,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTypography.h3),
                      if (item.metaInfo != null) ...[
                        const SizedBox(height: 6),
                        DndAccentPill(
                          label: item.metaInfo!,
                          accentColor: typeColor,
                          isFilled: true,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onFavoriteToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(
                    item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: item.isFavorite ? AppColors.danger : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.shortDescription,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
