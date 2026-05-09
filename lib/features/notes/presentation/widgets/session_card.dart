import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_fantasy_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../domain/models/session.dart';

class SessionCard extends StatelessWidget {
  final CampaignSession session;
  final VoidCallback onDelete;

  const SessionCard({
    super.key,
    required this.session,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DndFantasyCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
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
                Text(session.summary, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
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
