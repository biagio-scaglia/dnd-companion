import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../domain/models/session.dart';
import '../../domain/models/attachment.dart';

class SessionCard extends StatelessWidget {
  final CampaignSession session;
  final List<Attachment> attachments;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final Function(String) onDeleteAttachment;

  const SessionCard({
    super.key,
    required this.session,
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
                  icon: Icons.menu_book_rounded,
                  accentColor: AppColors.magicAccent,
                  size: 42,
                  showGlow: false,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.title, style: AppTypography.h3),
                      const SizedBox(height: 2),
                      Text(session.shortRecap, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
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
