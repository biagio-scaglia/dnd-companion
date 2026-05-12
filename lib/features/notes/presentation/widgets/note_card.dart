import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_chip.dart';
import '../../domain/models/note.dart';
import '../../domain/models/attachment.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final List<Attachment> attachments;
  final VoidCallback onTap;
  final Function(String) onDeleteAttachment;

  const NoteCard({
    super.key,
    required this.note,
    required this.attachments,
    required this.onTap,
    required this.onDeleteAttachment,
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
                              content: Text(AppLocalizations.of(context)!.deleteAttachmentConfirm, style: AppTypography.bodySmall),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.textSecondary)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onDeleteAttachment(a.id);
                                  },
                                  child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
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
