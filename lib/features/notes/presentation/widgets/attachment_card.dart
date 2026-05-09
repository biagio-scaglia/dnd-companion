import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../domain/models/attachment.dart';

class AttachmentCard extends StatelessWidget {
  final Attachment attachment;
  final VoidCallback onDelete;

  const AttachmentCard({
    super.key,
    required this.attachment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DndCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insert_drive_file_rounded, color: AppColors.naturalAccent, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(attachment.fileName, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                    Text(attachment.type.toUpperCase(), style: AppTypography.caption),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 18),
                onPressed: onDelete,
              ),
            ],
          ),
          if (attachment.type == 'image') ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _showFullscreenImage(context, attachment.filePath),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(attachment.filePath),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: AppColors.surfaceSecondary,
                      child: const Center(
                        child: Icon(Icons.broken_image_rounded, color: AppColors.textSecondary),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
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
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
