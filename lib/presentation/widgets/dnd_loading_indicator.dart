import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Indicatore di caricamento a tema D&D con animazione pulse.
class DndLoadingIndicator extends StatefulWidget {
  final String? message;

  const DndLoadingIndicator({super.key, this.message});

  @override
  State<DndLoadingIndicator> createState() => _DndLoadingIndicatorState();
}

class _DndLoadingIndicatorState extends State<DndLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _pulseAnimation,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.magicAccent.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.magicAccent.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.magicAccent,
                size: 28,
              ),
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _pulseAnimation,
              child: Text(
                widget.message!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
