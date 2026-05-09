import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../controllers/map_editor_controller.dart';

class LayerPanel extends StatelessWidget {
  const LayerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapEditorController>();
    final map = controller.currentMap;
    
    if (map == null) return const SizedBox.shrink();

    return DndCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIVELLI',
                style: AppTypography.label.copyWith(color: AppColors.magicAccent),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent, size: 20),
                onPressed: () => _showAddLayerDialog(context, controller),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...map.layers.map((layer) {
            final isActive = controller.activeLayerId == layer.id;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: IconButton(
                icon: Icon(
                  layer.isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  color: layer.isVisible ? AppColors.textPrimary : AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () => controller.toggleLayerVisibility(layer.id),
              ),
              title: Text(
                layer.name,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.magicAccent : AppColors.textPrimary,
                ),
              ),
              trailing: isActive 
                  ? IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 16, color: AppColors.magicAccent),
                      onPressed: () => _showRenameDialog(context, controller, layer.id, layer.name),
                    )
                  : null,
              onTap: () {
                controller.setActiveLayer(layer.id);
              },
            );
          }),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, MapEditorController controller, String layerId, String currentName) {
    final textController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Rinomina Livello', style: AppTypography.h3),
        content: TextField(
          controller: textController,
          style: AppTypography.body,
          decoration: const InputDecoration(
            hintText: 'Nome livello',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.renameLayer(layerId, textController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Salva', style: TextStyle(color: AppColors.magicAccent)),
          ),
        ],
      ),
    );
  }

  void _showAddLayerDialog(BuildContext context, MapEditorController controller) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Aggiungi Livello', style: AppTypography.h3),
        content: TextField(
          controller: textController,
          style: AppTypography.body,
          decoration: const InputDecoration(
            hintText: 'Nome livello (es. Trappole)',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.addLayer(textController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Aggiungi', style: TextStyle(color: AppColors.magicAccent)),
          ),
        ],
      ),
    );
  }
}
