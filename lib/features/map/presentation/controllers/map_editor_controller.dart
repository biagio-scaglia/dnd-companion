import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/game_map.dart';
import '../../domain/models/map_element.dart';
import '../../domain/models/map_layer.dart';
import '../../domain/models/map_tile_type.dart';
import '../../domain/repositories/map_repository.dart';

enum MapEditorTool { brush, eraser, pan }

class MapEditorController extends ChangeNotifier {
  final MapRepository _repository;
  final Uuid _uuid = const Uuid();

  MapEditorController(this._repository);

  // Stato UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Stato Editor
  final List<GameMap> _openMaps = [];
  List<GameMap> get openMaps => _openMaps;

  String? _activeMapId;
  String? get activeMapId => _activeMapId;

  GameMap? get currentMap {
    if (_activeMapId == null || _openMaps.isEmpty) return null;
    final index = _openMaps.indexWhere((m) => m.id == _activeMapId);
    if (index != -1) return _openMaps[index];
    return _openMaps.first;
  }

  MapEditorTool _selectedTool = MapEditorTool.pan;
  MapEditorTool get selectedTool => _selectedTool;

  MapTileType _selectedTileType = MapTileType.wallStone;
  MapTileType get selectedTileType => _selectedTileType;

  String _selectedEmoji = '🧱';
  String get selectedEmoji => _selectedEmoji;

  String? _activeLayerId;
  String? get activeLayerId => _activeLayerId;

  // Caricamento mappe
  Future<void> loadMap(String mapId) async {
    // Se è già aperta, la rendiamo solo attiva
    final index = _openMaps.indexWhere((m) => m.id == mapId);
    if (index != -1) {
      _activeMapId = mapId;
      _activeLayerId = _openMaps[index].layers.isNotEmpty ? _openMaps[index].layers.first.id : null;
      notifyListeners();
      return;
    }

    _setLoading(true);
    final map = await _repository.getMapById(mapId);
    if (map != null) {
      _openMaps.add(map);
      _activeMapId = map.id;
      if (map.layers.isNotEmpty) {
        _activeLayerId = map.layers.first.id;
      }
    }
    _setLoading(false);
  }

  Future<void> createNewMap(String name, int width, int height) async {
    _setLoading(true);
    
    final baseLayer = MapLayer(id: _uuid.v4(), name: 'Base');
    
    final newMap = GameMap(
      id: _uuid.v4(),
      name: name,
      width: width,
      height: height,
      layers: [baseLayer],
    );
    
    final savedMap = await _repository.saveMap(newMap);
    _openMaps.add(savedMap);
    _activeMapId = savedMap.id;
    _activeLayerId = baseLayer.id;
    
    _setLoading(false);
  }

  void setActiveMap(String mapId) {
    _activeMapId = mapId;
    final map = currentMap;
    if (map != null && map.layers.isNotEmpty) {
      _activeLayerId = map.layers.first.id;
    }
    notifyListeners();
  }

  void closeMap(String mapId) {
    _openMaps.removeWhere((m) => m.id == mapId);
    if (_activeMapId == mapId) {
      _activeMapId = _openMaps.isNotEmpty ? _openMaps.first.id : null;
      final map = currentMap;
      _activeLayerId = (map != null && map.layers.isNotEmpty) ? map.layers.first.id : null;
    }
    notifyListeners();
  }

  Future<void> saveCurrentMap() async {
    final map = currentMap;
    if (map == null) return;
    _setLoading(true);
    final savedMap = await _repository.saveMap(map);
    final index = _openMaps.indexWhere((m) => m.id == map.id);
    if (index != -1) {
      _openMaps[index] = savedMap;
    }
    _setLoading(false);
  }

  // Azioni Strumenti
  void selectTool(MapEditorTool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void selectTileType(MapTileType type) {
    _selectedTileType = type;
    notifyListeners();
  }

  void selectEmoji(String emoji) {
    _selectedEmoji = emoji;
    _selectedTileType = MapTileType.emoji; // Automatizza la selezione del tipo
    notifyListeners();
  }
  
  void setActiveLayer(String layerId) {
    _activeLayerId = layerId;
    notifyListeners();
  }

  // Interazioni dal Canvas (Flame)
  void handleTileInteraction(int x, int y) {
    final map = currentMap;
    if (map == null || _activeLayerId == null) return;
    if (_selectedTool == MapEditorTool.pan) return; // Pan gestito dalla camera Flame

    final layerIndex = map.layers.indexWhere((l) => l.id == _activeLayerId);
    if (layerIndex == -1) return;

    final layer = map.layers[layerIndex];
    if (!layer.isVisible) return; // Non modifichiamo layer invisibili

    // Troviamo se c'è già un elemento in questa cella nel layer corrente
    final existingElementIndex = layer.elements.indexWhere((e) => e.gridX == x && e.gridY == y);

    bool changed = false;

    if (_selectedTool == MapEditorTool.brush) {
      if (existingElementIndex >= 0) {
        // Aggiorniamo se diverso
        if (layer.elements[existingElementIndex].type != _selectedTileType) {
          layer.elements[existingElementIndex] = layer.elements[existingElementIndex].copyWith(type: _selectedTileType);
          changed = true;
        }
      } else {
        // Aggiungiamo nuovo
        layer.elements.add(MapElement(
          id: _uuid.v4(),
          gridX: x,
          gridY: y,
          type: _selectedTileType,
          emoji: _selectedTileType == MapTileType.emoji ? _selectedEmoji : null,
        ));
        changed = true;
      }
    } else if (_selectedTool == MapEditorTool.eraser) {
      if (existingElementIndex >= 0) {
        layer.elements.removeAt(existingElementIndex);
        changed = true;
      }
    }

    if (changed) {
      // In un'app reale con history (undo/redo), qui salveremmo lo stato precedente.
      // Notifichiamo i listener (incluso Flame che si aggiornerà)
      notifyListeners();
    }
  }

  void renameLayer(String layerId, String newName) {
    final map = currentMap;
    if (map == null) return;
    final index = map.layers.indexWhere((l) => l.id == layerId);
    if (index != -1) {
      map.layers[index] = map.layers[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  void addLayer(String name) {
    final map = currentMap;
    if (map == null) return;
    final newLayer = MapLayer(id: _uuid.v4(), name: name);
    map.layers.add(newLayer);
    notifyListeners();
  }

  void deleteLayer(String layerId) {
    final map = currentMap;
    if (map == null) return;
    if (map.layers.length <= 1) return; // Non eliminare l'ultimo
    
    map.layers.removeWhere((l) => l.id == layerId);
    
    // Se il livello attivo era quello eliminato, imposta il primo come attivo
    if (_activeLayerId == layerId) {
      _activeLayerId = map.layers.first.id;
    }
    notifyListeners();
  }

  void toggleLayerVisibility(String layerId) {
    final map = currentMap;
    if (map == null) return;
    final index = map.layers.indexWhere((l) => l.id == layerId);
    if (index != -1) {
      final layer = map.layers[index];
      map.layers[index] = layer.copyWith(isVisible: !layer.isVisible);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
