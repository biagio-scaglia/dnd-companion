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
import 'package:flutter/gestures.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import '../../../presentation/widgets/dnd_empty_state.dart';
import 'controllers/map_editor_controller.dart';
import '../game/map_editor_game.dart';
import 'widgets/layer_panel.dart';
import 'widgets/tile_palette.dart';
import 'widgets/tool_bar.dart';
import '../domain/models/map_tile_type.dart';

class MapTabView extends StatefulWidget {
  const MapTabView({super.key});

  @override
  State<MapTabView> createState() => _MapTabViewState();
}

class _MapTabViewState extends State<MapTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late MapEditorGame _game;
  final GlobalKey _screenshotKey = GlobalKey();
  double _baseScale = 1.0;
  bool _isUIVisible = true;

  @override
  void initState() {
    super.initState();
    _game = MapEditorGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapEditorController>().createNewMap(AppLocalizations.of(context)!.newMap, 30, 30);
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
        final storageStatus = await Permission.storage.status;
        final photosStatus = await Permission.photos.status;
        
        if (!storageStatus.isGranted && !photosStatus.isGranted) {
          final result = await [Permission.storage, Permission.photos].request();
          if (result[Permission.storage] != PermissionStatus.granted && 
              result[Permission.photos] != PermissionStatus.granted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.storagePermissionDenied)),
            );
            return;
          }
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
          SnackBar(content: Text(AppLocalizations.of(context)!.webSaveNotImplemented)),
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
            SnackBar(content: Text(AppLocalizations.of(context)!.mapSavedToGallery)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.saveError)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.errorPrefix}: $e')),
      );
    }
  }

  void _showRenameDialog(BuildContext context, MapEditorController controller, dynamic map) {
    final TextEditingController textController = TextEditingController(text: map.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.renameMap),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.mapNameLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  controller.renameMap(map.id, textController.text);
                }
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mapEditor),
        actions: [
          IconButton(
            icon: Icon(_isUIVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.magicAccent),
            onPressed: () {
              setState(() {
                _isUIVisible = !_isUIVisible;
              });
            },
            tooltip: _isUIVisible ? AppLocalizations.of(context)!.hideUI : AppLocalizations.of(context)!.showUI,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent),
            onPressed: () {
              context.read<MapEditorController>().createNewMap(AppLocalizations.of(context)!.newMap, 30, 30);
            },
            tooltip: AppLocalizations.of(context)!.newMap,
          ),
          IconButton(
            icon: const Icon(Icons.photo_camera_rounded, color: AppColors.magicAccent),
            onPressed: _captureAndSaveImage,
            tooltip: AppLocalizations.of(context)!.exportAsImage,
          ),
          IconButton(
            icon: const Icon(Icons.save_rounded, color: AppColors.magicAccent),
            onPressed: () {
              context.read<MapEditorController>().saveCurrentMap();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.mapSaved)),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Consumer<MapEditorController>(
            builder: (context, controller, child) {
              return Container(
                height: 40,
                color: AppColors.surface,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.openMaps.length,
                  itemBuilder: (context, index) {
                    final map = controller.openMaps[index];
                    final isSelected = map.id == controller.activeMapId;
                    return InkWell(
                      onTap: () => controller.setActiveMap(map.id),
                      onDoubleTap: () => _showRenameDialog(context, controller, map),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.surfaceSecondary : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? AppColors.magicAccent : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              map.name,
                              style: TextStyle(
                                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => controller.closeMap(map.id),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: Consumer<MapEditorController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return DndLoadingIndicator(message: AppLocalizations.of(context)!.loadingEditor);
          }

          if (controller.openMaps.isEmpty) {
            return DndEmptyState(
              imagePath: 'lib/assets/icone/Misc/Map.png',
              message: AppLocalizations.of(context)!.noMapOpen,
              subMessage: AppLocalizations.of(context)!.tapPlusToCreate,
              actionLabel: AppLocalizations.of(context)!.createNewMap,
              onAction: () => controller.createNewMap(AppLocalizations.of(context)!.newMap, 30, 30),
              accentColor: AppColors.magicAccent,
            );
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
                child: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      final controller = context.read<MapEditorController>();
                      // Permettiamo lo zoom con la rotella solo quando è selezionata la "Mano" (Pan)
                      if (controller.selectedTool == MapEditorTool.pan) {
                        final delta = pointerSignal.scrollDelta.dy;
                        final currentZoom = _game.mapCamera.viewfinder.zoom;
                        // Regola la sensibilità dello zoom (0.001 è un buon valore)
                        final newZoom = (currentZoom - delta * 0.001).clamp(0.5, 3.0);
                        setState(() {
                          _game.mapCamera.viewfinder.zoom = newZoom;
                        });
                      }
                    }
                  },
                  child: GestureDetector(
                    onTapDown: isPanTool
                        ? null
                        : (d) => _handlePointerAt(
                              d.localPosition.dx,
                              d.localPosition.dy,
                            ),
                    onScaleStart: (details) {
                      _baseScale = _game.mapCamera.viewfinder.zoom;
                    },
                    onScaleUpdate: (details) {
                      if (isPanTool) {
                        // Gestione Zoom da touch (pinch)
                        if (details.scale != 1.0) {
                          _game.mapCamera.viewfinder.zoom = (_baseScale * details.scale).clamp(0.5, 3.0);
                        }
                        // Gestione Pan
                        _game.mapCamera.viewfinder.position -= Vector2(
                          details.focalPointDelta.dx / _game.mapCamera.viewfinder.zoom,
                          details.focalPointDelta.dy / _game.mapCamera.viewfinder.zoom,
                        );
                      } else {
                        _handlePointerAt(
                          details.localFocalPoint.dx,
                          details.localFocalPoint.dy,
                        );
                      }
                    },
                    child: GameWidget(game: _game),
                  ),
                ),
              ),

              // UI sovrapposta (strumenti, palette, livelli)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isUIVisible 
                      ? (isMobile ? _buildMobileUI() : _buildDesktopUI())
                      : _buildMiniFloatingBar(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: ToolBar(),
          ),
          const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildDesktopUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ToolBar(),
            SizedBox(height: 16),
            SizedBox(width: 250, child: LayerPanel()),
          ],
        ),
        const SizedBox(width: 250, child: TilePalette()),
      ],
    );
  }

  Widget _buildMiniFloatingBar() {
    final controller = context.watch<MapEditorController>();
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceSecondary, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Strumenti rapidi: Pennello e Gomma
            IconButton(
              icon: const Icon(Icons.brush_rounded, size: 20),
              color: controller.selectedTool == MapEditorTool.brush ? AppColors.magicAccent : AppColors.textSecondary,
              onPressed: () => controller.selectTool(MapEditorTool.brush),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: AppLocalizations.of(context)!.brush,
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.backspace_rounded, size: 20),
              color: controller.selectedTool == MapEditorTool.eraser ? AppColors.magicAccent : AppColors.textSecondary,
              onPressed: () => controller.selectTool(MapEditorTool.eraser),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: AppLocalizations.of(context)!.eraser,
            ),
            const SizedBox(width: 12),
            // Preview Tile corrente
            if (controller.selectedTileType == MapTileType.emoji)
              controller.selectedEmoji.endsWith('.png')
                  ? Image.asset(controller.selectedEmoji, width: 20, height: 20, fit: BoxFit.contain)
                  : Text(
                      controller.selectedEmoji,
                      style: const TextStyle(fontSize: 18),
                    )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _getColorForType(controller.selectedTileType),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            const SizedBox(width: 12),
            const SizedBox(height: 20, child: VerticalDivider(color: AppColors.surfaceSecondary, width: 16)),
            // Pulsante per ripristinare la UI
            IconButton(
              icon: const Icon(Icons.fullscreen_rounded, color: AppColors.textSecondary, size: 20),
              onPressed: () {
                setState(() {
                  _isUIVisible = true;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: AppLocalizations.of(context)!.showTools,
            ),
          ],
        ),
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
