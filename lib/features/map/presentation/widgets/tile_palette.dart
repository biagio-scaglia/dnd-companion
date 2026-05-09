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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surfaceSecondary),
            ),
            child: DropdownButton<MapTileType>(
              value: controller.selectedTileType == MapTileType.emoji ? null : controller.selectedTileType,
              dropdownColor: AppColors.surface,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text('Seleziona Tile', style: AppTypography.bodySmall),
              items: MapTileType.values.where((e) => e != MapTileType.emoji).map((type) {
                return DropdownMenuItem<MapTileType>(
                  value: type,
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _getColorForType(type),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: type.isSolid 
                          ? Center(child: Container(width: 4, height: 4, color: Colors.black45))
                          : null,
                      ),
                      const SizedBox(width: 12),
                      Text(type.name.toUpperCase(), style: AppTypography.bodySmall),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (type) {
                if (type != null) {
                  controller.selectTool(MapEditorTool.brush);
                  controller.selectTileType(type);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceSecondary),
          const SizedBox(height: 8),
          Text(
            'EMOJI',
            style: AppTypography.label.copyWith(color: AppColors.magicAccent),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surfaceSecondary),
            ),
            child: DropdownButton<String>(
              value: controller.selectedTileType == MapTileType.emoji ? controller.selectedEmoji : null,
              dropdownColor: AppColors.surface,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text('Seleziona Emoji', style: AppTypography.bodySmall),
              items: [
                {'emoji': '🧱', 'name': 'Mura'},
                {'emoji': '🪵', 'name': 'Legno'},
                {'emoji': '💧', 'name': 'Acqua'},
                {'emoji': '🔥', 'name': 'Fuoco'},
                {'emoji': '🚪', 'name': 'Porta'},
                {'emoji': '📦', 'name': 'Cassa'},
                {'emoji': '🌲', 'name': 'Albero'},
                {'emoji': '🪨', 'name': 'Roccia'},
                {'emoji': '🏰', 'name': 'Castello'},
                {'emoji': '👹', 'name': 'Mostro'},
                {'emoji': '🧙', 'name': 'Mago'},
                {'emoji': '🐉', 'name': 'Drago'},
                {'emoji': '💀', 'name': 'Teschio'},
                {'emoji': '💰', 'name': 'Tesoro'},
              ].map((e) {
                return DropdownMenuItem<String>(
                  value: e['emoji'],
                  child: Row(
                    children: [
                      Text(e['emoji']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Text(e['name']!, style: AppTypography.bodySmall),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (emoji) {
                if (emoji != null) {
                  controller.selectEmoji(emoji);
                }
              },
            ),
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
      case MapTileType.emoji: return Colors.transparent;
    }
  }
}
