import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
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
        typeIcon = Icons.pets_rounded;
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceSecondary, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (item.metaInfo != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.metaInfo!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: typeColor.withOpacity(0.8),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: item.isFavorite ? AppColors.danger : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.shortDescription,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
