import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../domain/models/map_tile_type.dart';
import '../controllers/map_editor_controller.dart';

class TilePalette extends StatelessWidget {
  const TilePalette({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapEditorController>();
    
    return DndCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TILE',
            style: AppTypography.label.copyWith(color: AppColors.highlight),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MapTileType.values.map((type) {
              final isSelected = controller.selectedTileType == type;
              return GestureDetector(
                onTap: () {
                  controller.selectTool(MapEditorTool.brush);
                  controller.selectTileType(type);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getColorForType(type),
                    border: Border.all(
                      color: isSelected ? AppColors.highlight : AppColors.surfaceSecondary,
                      width: isSelected ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.highlight.withValues(alpha: 0.3),
                              blurRadius: 8,
                            )
                          ]
                        : null,
                  ),
                  child: type.isSolid 
                    ? Center(child: Container(width: 8, height: 8, color: Colors.black45))
                    : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColorForType(MapTileType type) {
    switch (type) {
      case MapTileType.floorStone: return const Color(0xFF424242);
      case MapTileType.floorWood: return const Color(0xFF5D4037);
      case MapTileType.floorDirt: return const Color(0xFF3E2723);
      case MapTileType.floorGrass: return const Color(0xFF4CAF50);
      case MapTileType.swamp: return const Color(0xFF2E7D32);
      case MapTileType.wallStone: return const Color(0xFF757575);
      case MapTileType.wallWood: return const Color(0xFF795548);
      case MapTileType.water: return const Color(0xFF1976D2);
      case MapTileType.lava: return const Color(0xFFE64A19);
      case MapTileType.doorClosed: return const Color(0xFFFFB300);
      case MapTileType.doorOpen: return const Color(0xFFFFE082);
      case MapTileType.stairsUp:
      case MapTileType.stairsDown: return const Color(0xFFBDBDBD);
      case MapTileType.chest: return AppColors.highlight;
      case MapTileType.table: return const Color(0xFF8D6E63);
      case MapTileType.barrel: return const Color(0xFFA1887F);
    }
  }
}
