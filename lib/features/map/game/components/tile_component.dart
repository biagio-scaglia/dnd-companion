import 'dart:ui';
import 'package:flame/components.dart';
import '../../domain/models/map_element.dart';
import '../../domain/models/map_tile_type.dart';
import '../../../../core/theme/app_colors.dart';

class TileComponent extends PositionComponent {
  final MapElement element;
  final double tileSize;

  TileComponent({
    required this.element,
    required this.tileSize,
  }) {
    size = Vector2(tileSize, tileSize);
    position = Vector2(element.gridX * tileSize, element.gridY * tileSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Al momento, in mancanza di asset (immagini), disegniamo i tile usando i colori
    // per rappresentare i vari tipi. In futuro qui caricheremo uno Sprite.
    final paint = Paint()..style = PaintingStyle.fill;
    
    switch (element.type) {
      case MapTileType.floorStone:
        paint.color = const Color(0xFF424242);
        break;
      case MapTileType.floorWood:
        paint.color = const Color(0xFF5D4037);
        break;
      case MapTileType.floorDirt:
        paint.color = const Color(0xFF3E2723);
        break;
      case MapTileType.wallStone:
        paint.color = const Color(0xFF757575);
        break;
      case MapTileType.wallWood:
        paint.color = const Color(0xFF795548);
        break;
      case MapTileType.water:
        paint.color = const Color(0xFF1976D2);
        break;
      case MapTileType.lava:
        paint.color = const Color(0xFFE64A19);
        break;
      case MapTileType.doorClosed:
        paint.color = const Color(0xFFFFB300);
        break;
      case MapTileType.doorOpen:
        paint.color = const Color(0xFFFFE082);
        break;
      case MapTileType.stairsUp:
      case MapTileType.stairsDown:
        paint.color = const Color(0xFFBDBDBD);
        break;
      case MapTileType.chest:
        paint.color = AppColors.highlight;
        break;
      case MapTileType.table:
        paint.color = const Color(0xFF8D6E63);
        break;
      case MapTileType.barrel:
        paint.color = const Color(0xFFA1887F);
        break;
    }
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    
    // Disegna un bordino o pattern a seconda del tipo per differenziarli meglio
    if (element.type.isSolid) {
      final borderPaint = Paint()
        ..color = const Color(0x66000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);
    }
  }
}
