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
          Text(
            'LIVELLI',
            style: AppTypography.label.copyWith(color: AppColors.magicAccent),
          ),
          const SizedBox(height: 8),
          ...map.layers.map((layer) {
            final isActive = controller.activeLayerId == layer.id;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: Icon(
                layer.isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                color: layer.isVisible ? AppColors.textPrimary : AppColors.textSecondary,
                size: 20,
              ),
              title: Text(
                layer.name,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.magicAccent : AppColors.textPrimary,
                ),
              ),
              trailing: isActive 
                  ? const Icon(Icons.edit_rounded, size: 16, color: AppColors.magicAccent)
                  : null,
              onTap: () {
                // In un editor completo si potrebbe nascondere cliccando sull'occhio, 
                // ma per semplicità ora cambiamo solo il layer attivo
                controller.setActiveLayer(layer.id);
              },
            );
          }),
        ],
      ),
    );
  }
}
