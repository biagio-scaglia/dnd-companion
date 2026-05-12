import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_radius.dart';
import '../../features/notes/domain/models/attachment.dart';
import 'dnd_card.dart';

class AttachmentSection extends StatelessWidget {
  final String linkedEntityId;
  final String linkedEntityType;
  final List<Attachment> attachments;
  final Function(Attachment) onDelete;
  final VoidCallback onAdd;

  const AttachmentSection({
    super.key,
    required this.linkedEntityId,
    required this.linkedEntityType,
    required this.attachments,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final filteredAttachments = attachments.where((a) => 
      a.linkedEntityId == linkedEntityId && a.linkedEntityType == linkedEntityType
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.attachments,
              style: AppTypography.h3.copyWith(color: AppColors.magicAccent),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.magicAccent),
              onPressed: onAdd,
              tooltip: AppLocalizations.of(context)!.addAttachment,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (filteredAttachments.isEmpty)
          DndCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_file_rounded, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.noAttachments,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredAttachments.length,
              itemBuilder: (context, index) {
                final attachment = filteredAttachments[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: _AttachmentCard(
                    attachment: attachment,
                    onDelete: () => onDelete(attachment),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final Attachment attachment;
  final VoidCallback onDelete;

  const _AttachmentCard({
    required this.attachment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = attachment.sourceType == 'image';
    
    return SizedBox(
      width: 100,
      child: DndCard(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: isImage
                      ? GestureDetector(
                          onTap: () => _showFullscreenImage(context, attachment.storedPath),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.file(
                              File(attachment.storedPath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image_rounded, color: AppColors.textSecondary),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: Icon(
                            _getIconForType(attachment.sourceType),
                            color: AppColors.magicAccent,
                            size: 32,
                          ),
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          attachment.fileName,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (attachment.fileSize != null)
                          Text(
                            _formatFileSize(attachment.fileSize!),
                            style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 2,
              right: 2,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 10, color: AppColors.danger),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullscreenImage(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Image.file(File(path)),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.danger, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
