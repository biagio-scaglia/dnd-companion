import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
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
  final GlobalKey _screenshotKey = GlobalKey();

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

  Future<void> _captureAndSaveImage() async {
    try {
      // 1. Richiedi permessi (su mobile)
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permesso di archiviazione negato!')),
          );
          return;
        }
      }

      // 2. Cattura l'immagine
      final boundary = _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0); // Alta definizione
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 3. Salva nel dispositivo
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salvataggio su Web non implementato direttamente. Usa screenshot!')),
        );
      } else {
        // Su mobile salviamo nella galleria usando image_gallery_saver_plus
        final result = await ImageGallerySaverPlus.saveImage(
          pngBytes,
          quality: 100,
          name: "mappa_${DateTime.now().millisecondsSinceEpoch}",
        );
        
        if (result != null && result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mappa salvata nella galleria!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Errore nel salvataggio!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
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
            icon: const Icon(Icons.photo_camera_rounded, color: AppColors.magicAccent),
            onPressed: _captureAndSaveImage,
            tooltip: 'Esporta come immagine',
          ),
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
              RepaintBoundary(
                key: _screenshotKey,
                child: GestureDetector(
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
