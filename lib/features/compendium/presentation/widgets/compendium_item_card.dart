import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../../../presentation/widgets/dnd_chip.dart';
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
    String? imagePath;
    IconData? typeIcon;
    Color typeColor;

    switch (item.type) {
      case CompendiumItemType.monster:
        imagePath = 'lib/assets/icone/Monster Part/Skull.png';
        typeColor = AppColors.danger;
        break;
      case CompendiumItemType.spell:
        imagePath = 'lib/assets/icone/Misc/Scroll.png';
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.item:
        imagePath = 'lib/assets/icone/Equipment/Iron Armor.png';
        typeColor = AppColors.highlight;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DndCard(
        showGlow: item.isFavorite,
        accentColor: AppColors.danger,
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
                  imagePath: imagePath,
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
                        DndChip(
                          label: item.metaInfo!,
                          accentColor: typeColor,
                          isSelected: true,
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
