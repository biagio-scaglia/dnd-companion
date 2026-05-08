import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/calendar_event.dart';

class CalendarEventCard extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onDelete;

  const CalendarEventCard({
    super.key,
    required this.event,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = '${event.date.day}/${event.date.month}/${event.date.year}';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceSecondary,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: event.isImportant ? AppColors.magicAccent.withOpacity(0.2) : AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              event.hasSession ? Icons.menu_book_rounded : Icons.event_rounded,
              color: event.isImportant ? AppColors.magicAccent : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (event.hasReminder)
            const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.highlight,
              size: 20,
            ),
          if (onDelete != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
