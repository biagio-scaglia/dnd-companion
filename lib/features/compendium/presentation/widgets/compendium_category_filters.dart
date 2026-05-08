import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/compendium_item.dart';

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
          _buildChip(
            label: 'Preferiti',
            icon: showOnlyFavorites ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            isSelected: showOnlyFavorites,
            onTap: onFavoritesTapped,
            activeColor: AppColors.danger,
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: AppColors.surfaceSecondary),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Mostri',
            icon: Icons.pets_rounded,
            isSelected: selectedCategory == CompendiumItemType.monster,
            onTap: () => onCategoryTapped(CompendiumItemType.monster),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Incantesimi',
            icon: Icons.auto_awesome_rounded,
            isSelected: selectedCategory == CompendiumItemType.spell,
            onTap: () => onCategoryTapped(CompendiumItemType.spell),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Oggetti',
            icon: Icons.shield_rounded,
            isSelected: selectedCategory == CompendiumItemType.item,
            onTap: () => onCategoryTapped(CompendiumItemType.item),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color activeColor = AppColors.highlight,
  }) {
    final bgColor = isSelected ? activeColor.withOpacity(0.15) : AppColors.surface;
    final textColor = isSelected ? activeColor : AppColors.textSecondary;
    final borderColor = isSelected ? activeColor.withOpacity(0.5) : AppColors.surfaceSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
