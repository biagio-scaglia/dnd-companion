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
            imagePath: 'lib/assets/icone/Monster Part/Skull.png',
            isSelected: selectedCategory == CompendiumItemType.monster,
            onTap: () => onCategoryTapped(CompendiumItemType.monster),
            accentColor: selectedCategory == CompendiumItemType.monster ? AppColors.magicAccent : AppColors.highlight,
          ),
          const SizedBox(width: 8),
          DndChip(
            label: 'Incantesimi',
            imagePath: 'lib/assets/icone/Misc/Scroll.png',
            isSelected: selectedCategory == CompendiumItemType.spell,
            onTap: () => onCategoryTapped(CompendiumItemType.spell),
            accentColor: selectedCategory == CompendiumItemType.spell ? AppColors.magicAccent : AppColors.highlight,
          ),
          const SizedBox(width: 8),
          DndChip(
            label: 'Oggetti',
            imagePath: 'lib/assets/icone/Equipment/Iron Armor.png',
            isSelected: selectedCategory == CompendiumItemType.item,
            onTap: () => onCategoryTapped(CompendiumItemType.item),
            accentColor: selectedCategory == CompendiumItemType.item ? AppColors.naturalAccent : AppColors.highlight,
          ),
        ],
      ),
    );
  }


}
