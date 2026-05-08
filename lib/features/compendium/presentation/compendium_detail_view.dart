import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/models/compendium_item.dart';

class CompendiumDetailView extends StatelessWidget {
  final CompendiumItem item;

  const CompendiumDetailView({super.key, required this.item});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio'),
        actions: [
          if (item.isFavorite)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.favorite_rounded, color: AppColors.danger),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (item.metaInfo != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.metaInfo!,
                            style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Descrizione',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
