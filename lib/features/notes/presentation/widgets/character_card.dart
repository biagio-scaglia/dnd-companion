import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../../../presentation/widgets/dnd_chip.dart';
import '../../domain/models/character.dart';
import '../../domain/models/attachment.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final List<Attachment> attachments;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final Function(String) onDeleteAttachment;

  const CharacterCard({
    super.key,
    required this.character,
    required this.attachments,
    required this.onDelete,
    required this.onTap,
    required this.onDeleteAttachment,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'link':
        return Icons.link_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DndCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: attachments.length,
                  itemBuilder: (context, index) {
                    final a = attachments[index];
                    final isImage = a.sourceType == 'image';
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              title: Text(a.fileName, style: AppTypography.h3),
                              content: Text('Vuoi eliminare questo allegato?', style: AppTypography.bodySmall),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onDeleteAttachment(a.id);
                                  },
                                  child: const Text('Elimina', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(4),
                            image: isImage ? DecorationImage(
                              image: FileImage(File(a.storedPath)),
                              fit: BoxFit.cover,
                            ) : null,
                          ),
                          child: !isImage ? Icon(
                            _getIconForType(a.sourceType),
                            color: AppColors.magicAccent,
                            size: 20,
                          ) : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
