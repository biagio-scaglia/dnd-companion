import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DndLoadingIndicator extends StatelessWidget {
  final String? message;

  const DndLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: AppColors.magicAccent,
              strokeWidth: 3,
              backgroundColor: AppColors.surfaceSecondary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
