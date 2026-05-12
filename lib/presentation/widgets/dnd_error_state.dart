import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'dnd_button.dart';

/// Stato di errore elegante e coerente col tono dark fantasy.
class DndErrorState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subMessage;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DndErrorState({
    super.key,
    this.icon = Icons.gavel_rounded,
    required this.message,
    this.subMessage,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xFF8C2D2D); // Rosso ruggine/sangue scuro

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: errorColor.withValues(alpha: 0.2), width: 1.5),
              ),
              child: Icon(icon, color: errorColor.withValues(alpha: 0.7), size: 32),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              message,
              style: AppTypography.h3.copyWith(color: errorColor),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                subMessage!,
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.l),
              DndButton(
                text: actionLabel!,
                onPressed: onAction!,
                backgroundColor: errorColor,
                foregroundColor: AppColors.textPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
