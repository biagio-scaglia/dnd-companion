import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/compendium_item.dart';
import '../../../../presentation/widgets/dnd_chip.dart';

class CompendiumCategoryFilters extends StatelessWidget {
  final CompendiumItemType? selectedCategory;
  final bool showOnlyFavorites;
  final Function(CompendiumItemType) onCategoryTapped;
  final VoidCallback onFavoritesTapped;

  const CompendiumCategoryFilters({
    super.key,
    required this.selectedCategory,
    required this.showOnlyFavorites,
    required this.onCategoryTapped,
    required this.onFavoritesTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          DndChip(
            label: 'Preferiti',
            icon: showOnlyFavorites ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            isSelected: showOnlyFavorites,
            onTap: onFavoritesTapped,
            accentColor: AppColors.danger,
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: AppColors.surfaceSecondary),
          const SizedBox(width: 8),
          DndChip(
            label: 'Mostri',
            icon: Icons.pets_rounded,
            isSelected: selectedCategory == CompendiumItemType.monster,
            onTap: () => onCategoryTapped(CompendiumItemType.monster),
            accentColor: selectedCategory == CompendiumItemType.monster ? AppColors.magicAccent : AppColors.highlight,
          ),
          const SizedBox(width: 8),
          DndChip(
            label: 'Incantesimi',
            icon: Icons.auto_awesome_rounded,
            isSelected: selectedCategory == CompendiumItemType.spell,
            onTap: () => onCategoryTapped(CompendiumItemType.spell),
            accentColor: selectedCategory == CompendiumItemType.spell ? AppColors.magicAccent : AppColors.highlight,
          ),
          const SizedBox(width: 8),
          DndChip(
            label: 'Oggetti',
            icon: Icons.shield_rounded,
            isSelected: selectedCategory == CompendiumItemType.item,
            onTap: () => onCategoryTapped(CompendiumItemType.item),
            accentColor: selectedCategory == CompendiumItemType.item ? AppColors.naturalAccent : AppColors.highlight,
          ),
        ],
      ),
    );
  }


}
