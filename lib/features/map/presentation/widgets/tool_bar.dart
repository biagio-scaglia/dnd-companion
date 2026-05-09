import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../controllers/map_editor_controller.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapEditorController>();
    
    return DndCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToolButton(
            icon: Icons.brush_rounded,
            isSelected: controller.selectedTool == MapEditorTool.brush,
            onTap: () => controller.selectTool(MapEditorTool.brush),
          ),
          const SizedBox(width: 4),
          _ToolButton(
            icon: Icons.backspace_rounded,
            isSelected: controller.selectedTool == MapEditorTool.eraser,
            onTap: () => controller.selectTool(MapEditorTool.eraser),
          ),
          const SizedBox(width: 4),
          _ToolButton(
            icon: Icons.pan_tool_rounded,
            isSelected: controller.selectedTool == MapEditorTool.pan,
            onTap: () => controller.selectTool(MapEditorTool.pan),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? AppColors.highlight : AppColors.textSecondary,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: isSelected 
          ? AppColors.highlight.withValues(alpha: 0.15) 
          : Colors.transparent,
      ),
    );
  }
}
