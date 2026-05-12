import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import '../domain/models/game_map.dart';
import 'components/grid_component.dart';
import 'components/tile_component.dart';
import '../../../../core/theme/app_colors.dart';

class MapEditorGame extends FlameGame with ScaleDetector {
  final double tileSize = 32.0;

  GameMap? currentMap;

  late World mapWorld;
  late CameraComponent mapCamera;

  MapEditorGame({this.currentMap});

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    images.prefix = ''; // Rimuove il prefisso 'assets/images/' di default di Flame
    mapWorld = World();
    mapCamera = CameraComponent(world: mapWorld);
    addAll([mapWorld, mapCamera]);
    _refreshMap();
  }

  void updateMap(GameMap newMap) {
    currentMap = newMap;
    if (isMounted) _refreshMap();
  }

  void _refreshMap() {
    mapWorld.removeAll(mapWorld.children);
    if (currentMap == null) return;

    mapWorld.add(GridComponent(
      gridWidth: currentMap!.width,
      gridHeight: currentMap!.height,
      tileSize: tileSize,
    ));

    for (final layer in currentMap!.layers) {
      if (!layer.isVisible) continue;
      for (final element in layer.elements) {
        mapWorld.add(TileComponent(element: element, tileSize: tileSize));
      }
    }

    if (mapCamera.viewfinder.position == Vector2.zero()) {
      mapCamera.viewfinder.position = Vector2(
        (currentMap!.width * tileSize) / 2,
        (currentMap!.height * tileSize) / 2,
      );
    }
  }

  /// Converte le coordinate schermo (pixel) in coordinate della griglia.
  /// Restituisce null se fuori dai limiti della mappa.
  (int, int)? screenToGrid(double screenX, double screenY) {
    if (currentMap == null) return null;
    final canvasSize = size;
    final zoom = mapCamera.viewfinder.zoom;
    final camPos = mapCamera.viewfinder.position;

    final worldX = (screenX - canvasSize.x / 2) / zoom + camPos.x;
    final worldY = (screenY - canvasSize.y / 2) / zoom + camPos.y;

    final gridX = (worldX / tileSize).floor();
    final gridY = (worldY / tileSize).floor();

    if (gridX < 0 || gridX >= currentMap!.width) return null;
    if (gridY < 0 || gridY >= currentMap!.height) return null;

    return (gridX, gridY);
  }

  // --- Zoom & pan a due dita ---
  late double _startZoom;

  @override
  void onScaleStart(ScaleStartInfo info) {
    _startZoom = mapCamera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final newZoom = (_startZoom * info.scale.global.y).clamp(0.2, 3.0);
    mapCamera.viewfinder.zoom = newZoom;

    // Pan con due dita
    if (info.pointerCount > 1) {
      mapCamera.viewfinder.position -=
          info.delta.global / mapCamera.viewfinder.zoom;
    }
  }
}
