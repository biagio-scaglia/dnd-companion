import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../../../presentation/widgets/dnd_chip.dart';
import '../../domain/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onDelete;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DndCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const DndMysticIconCircle(
            icon: Icons.person_rounded,
            accentColor: AppColors.highlight,
            size: 42,
            showGlow: false,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(character.name, style: AppTypography.h3),
                const SizedBox(height: 4),
                DndChip(
                  label: '${character.race} • ${character.characterClass} • Liv. ${character.level}',
                  accentColor: AppColors.highlight,
                  isSelected: true,
                ),
                if (character.status != CharacterStatus.attivo) ...[
                  const SizedBox(height: 4),
                  DndChip(
                    label: character.status == CharacterStatus.npcAlly ? 'Alleato' : (character.status == CharacterStatus.morto ? 'Morto' : 'Ritirato'),
                    accentColor: character.status == CharacterStatus.morto ? AppColors.danger : AppColors.textSecondary,
                    isSelected: false,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
