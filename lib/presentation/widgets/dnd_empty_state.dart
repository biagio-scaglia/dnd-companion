import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'dnd_button.dart';

/// Stato vuoto elegante e coerente.
/// Usare in ogni lista vuota dell'app.
class DndEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subMessage;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color accentColor;
  final bool isCompact;

  const DndEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subMessage,
    this.actionLabel,
    this.onAction,
    this.accentColor = AppColors.magicAccent,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? AppSpacing.m : AppSpacing.xl,
          vertical: isCompact ? AppSpacing.m : AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isCompact ? 48 : 72,
              height: isCompact ? 48 : 72,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: accentColor.withValues(alpha: 0.15), width: 1.5),
              ),
              child: Icon(icon, color: accentColor.withValues(alpha: 0.6), size: isCompact ? 24 : 32),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              message,
              style: isCompact ? AppTypography.body.copyWith(fontWeight: FontWeight.bold) : AppTypography.h3,
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
