import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_chip.dart';
import '../../domain/models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'png':
      case 'npc':
        return Colors.green;
      case 'combattimento':
      case 'combat':
        return Colors.red;
      case 'lore':
      case 'storia':
        return Colors.blue;
      case 'oggetti':
      case 'loot':
        return Colors.orange;
      case 'mistero':
        return Colors.purple;
      default:
        return AppColors.naturalAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DndCard(
        showGlow: note.isImportant,
        accentColor: AppColors.magicAccent,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: AppTypography.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (note.isImportant)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.star_rounded,
                      color: AppColors.magicAccent,
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: AppTypography.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: note.tags
                    .map((tag) => DndChip(
                          label: tag,
                          accentColor: _getTagColor(tag),
                          isSelected: true,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
