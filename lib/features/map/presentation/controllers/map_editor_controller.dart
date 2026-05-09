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
  GameMap? _currentMap;
  GameMap? get currentMap => _currentMap;

  MapEditorTool _selectedTool = MapEditorTool.pan;
  MapEditorTool get selectedTool => _selectedTool;

  MapTileType _selectedTileType = MapTileType.wallStone;
  MapTileType get selectedTileType => _selectedTileType;

  String? _activeLayerId;
  String? get activeLayerId => _activeLayerId;

  // Caricamento mappe
  Future<void> loadMap(String mapId) async {
    _setLoading(true);
    _currentMap = await _repository.getMapById(mapId);
    if (_currentMap != null && _currentMap!.layers.isNotEmpty) {
      _activeLayerId = _currentMap!.layers.first.id;
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
    
    _currentMap = await _repository.saveMap(newMap);
    _activeLayerId = baseLayer.id;
    
    _setLoading(false);
  }

  Future<void> saveCurrentMap() async {
    if (_currentMap == null) return;
    _setLoading(true);
    _currentMap = await _repository.saveMap(_currentMap!);
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
  
  void setActiveLayer(String layerId) {
    _activeLayerId = layerId;
    notifyListeners();
  }

  // Interazioni dal Canvas (Flame)
  void handleTileInteraction(int x, int y) {
    if (_currentMap == null || _activeLayerId == null) return;
    if (_selectedTool == MapEditorTool.pan) return; // Pan gestito dalla camera Flame

    final layerIndex = _currentMap!.layers.indexWhere((l) => l.id == _activeLayerId);
    if (layerIndex == -1) return;

    final layer = _currentMap!.layers[layerIndex];
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
    if (_currentMap == null) return;
    final index = _currentMap!.layers.indexWhere((l) => l.id == layerId);
    if (index != -1) {
      _currentMap!.layers[index] = _currentMap!.layers[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  void toggleLayerVisibility(String layerId) {
    if (_currentMap == null) return;
    final index = _currentMap!.layers.indexWhere((l) => l.id == layerId);
    if (index != -1) {
      final layer = _currentMap!.layers[index];
      _currentMap!.layers[index] = layer.copyWith(isVisible: !layer.isVisible);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
