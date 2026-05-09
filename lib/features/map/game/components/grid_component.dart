import 'dart:ui';
import 'package:flame/components.dart';
import '../../../../core/theme/app_colors.dart';

/// Griglia visiva pura — gestisce solo il rendering.
/// Gli input (tap, drag) sono gestiti dal GestureDetector Flutter in MapTabView.
class GridComponent extends PositionComponent {
  final int gridWidth;
  final int gridHeight;
  final double tileSize;

  GridComponent({
    required this.gridWidth,
    required this.gridHeight,
    required this.tileSize,
  }) {
    size = Vector2(gridWidth * tileSize, gridHeight * tileSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final linePaint = Paint()
      ..color = AppColors.surfaceSecondary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int x = 0; x <= gridWidth; x++) {
      canvas.drawLine(
        Offset(x * tileSize, 0),
        Offset(x * tileSize, size.y),
        linePaint,
      );
    }

    for (int y = 0; y <= gridHeight; y++) {
      canvas.drawLine(
        Offset(0, y * tileSize),
        Offset(size.x, y * tileSize),
        linePaint,
      );
    }

    final borderPaint = Paint()
      ..color = AppColors.surfaceSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);
  }
}
