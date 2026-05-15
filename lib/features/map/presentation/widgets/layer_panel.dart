import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd/l10n/app_localizations.dart';
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
                AppLocalizations.of(context)!.layers.toUpperCase(),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cleaning_services_rounded, size: 16, color: AppColors.textSecondary),
                    onPressed: () => _showClearConfirmDialog(context, controller, layer.id, layer.name),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: AppLocalizations.of(context)!.reset,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 16, color: AppColors.textSecondary),
                    onPressed: () => _showRenameDialog(context, controller, layer.id, layer.name),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.danger),
                    onPressed: () {
                      if (map.layers.length > 1) {
                        _showDeleteConfirmDialog(context, controller, layer.id, layer.name);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.cannotDeleteLastLayer)),
                        );
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
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
        title: Text(AppLocalizations.of(context)!.renameLayer, style: AppTypography.h3),
        content: TextField(
          controller: textController,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.layerName,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.renameLayer(layerId, textController.text);
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save, style: const TextStyle(color: AppColors.magicAccent)),
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
        title: Text(AppLocalizations.of(context)!.addLayer, style: AppTypography.h3),
        content: TextField(
          controller: textController,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.layerNameExample,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.addLayer(textController.text);
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.add, style: const TextStyle(color: AppColors.magicAccent)),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmDialog(BuildContext context, MapEditorController controller, String layerId, String layerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppLocalizations.of(context)!.reset, style: AppTypography.h3),
        content: Text("${AppLocalizations.of(context)!.deleteLayerConfirm(layerName).split('?')[0]}?", style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              controller.setActiveLayer(layerId);
              controller.clearActiveLayer();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.reset, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, MapEditorController controller, String layerId, String layerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppLocalizations.of(context)!.deleteLayer, style: AppTypography.h3),
        content: Text(AppLocalizations.of(context)!.deleteLayerConfirm(layerName), style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteLayer(layerId);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}
