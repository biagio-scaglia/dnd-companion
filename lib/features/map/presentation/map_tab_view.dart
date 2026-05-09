import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import 'controllers/map_editor_controller.dart';
import '../game/map_editor_game.dart';
import 'widgets/layer_panel.dart';
import 'widgets/tile_palette.dart';
import 'widgets/tool_bar.dart';

class MapTabView extends StatefulWidget {
  const MapTabView({super.key});

  @override
  State<MapTabView> createState() => _MapTabViewState();
}

class _MapTabViewState extends State<MapTabView> {
  late MapEditorGame _game;

  @override
  void initState() {
    super.initState();
    _game = MapEditorGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapEditorController>().createNewMap('Nuova Mappa', 30, 30);
    });
  }

  void _handlePointerAt(double x, double y) {
    final coords = _game.screenToGrid(x, y);
    if (coords != null) {
      final (gridX, gridY) = coords;
      context.read<MapEditorController>().handleTileInteraction(gridX, gridY);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editor Mappa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: AppColors.magicAccent),
            onPressed: () {
              context.read<MapEditorController>().saveCurrentMap();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mappa salvata!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<MapEditorController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const DndLoadingIndicator(message: 'Caricamento editor...');
          }

          if (controller.currentMap != null) {
            _game.updateMap(controller.currentMap!);
          }

          final isMobile = MediaQuery.of(context).size.width < 800;
          final isPanTool = controller.selectedTool == MapEditorTool.pan;

          return Stack(
            children: [
              // Canvas Flame con GestureDetector Flutter
              GestureDetector(
                onTapDown: isPanTool
                    ? null
                    : (d) => _handlePointerAt(
                          d.localPosition.dx,
                          d.localPosition.dy,
                        ),
                onPanUpdate: (d) {
                  if (isPanTool) {
                    final zoom = _game.mapCamera.viewfinder.zoom;
                    _game.mapCamera.viewfinder.position -= Vector2(
                      d.delta.dx / zoom,
                      d.delta.dy / zoom,
                    );
                  } else {
                    _handlePointerAt(
                      d.localPosition.dx,
                      d.localPosition.dy,
                    );
                  }
                },
                child: GameWidget(game: _game),
              ),

              // UI sovrapposta (strumenti, palette, livelli)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isMobile ? _buildMobileUI() : _buildDesktopUI(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: ToolBar(),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            LayerPanel(),
            SizedBox(height: 8),
            TilePalette(),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolBar(),
            SizedBox(height: 16),
            LayerPanel(),
          ],
        ),
        TilePalette(),
      ],
    );
  }
}
