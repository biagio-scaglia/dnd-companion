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
            icon: Icons.pan_tool_rounded, // Keep standard for Pan as it's very clear!
            isSelected: controller.selectedTool == MapEditorTool.pan,
            onTap: () => controller.selectTool(MapEditorTool.pan),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolButton({
    this.icon,
    this.imagePath,
    required this.isSelected,
    required this.onTap,
  }) : assert(icon != null || imagePath != null);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: imagePath != null
          ? Image.asset(
              imagePath!,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              // If it's a colored icon, we might not want to tint it!
              // Let's assume we don't tint it, or we use color for selected state if it's grayscale!
              // Let's not tint it for now!
            )
          : Icon(icon, size: 20),
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
