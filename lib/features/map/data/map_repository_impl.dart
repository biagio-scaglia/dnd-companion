import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/game_map.dart';
import '../domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  static const String _storageKey = 'dnd_maps_data';
  List<GameMap> _cachedMaps = [];
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    
    if (jsonStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _cachedMaps = decoded.map((e) => GameMap.fromJson(e)).toList();
      } catch (e) {
        print('Error decoding maps: $e');
        _cachedMaps = [];
      }
    }
    _initialized = true;
  }

  Future<void> _persistData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_cachedMaps.map((m) => m.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  @override
  Future<List<GameMap>> getMaps() async {
    await _init();
    // Return a copy to avoid unintended mutations
    return List.from(_cachedMaps);
  }

  @override
  Future<GameMap?> getMapById(String id) async {
    await _init();
    try {
      return _cachedMaps.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<GameMap> saveMap(GameMap map) async {
    await _init();
    
    // Aggiorna updatedAt
    final updatedMap = map.copyWith(updatedAt: DateTime.now());
    
    final index = _cachedMaps.indexWhere((m) => m.id == updatedMap.id);
    if (index >= 0) {
      _cachedMaps[index] = updatedMap;
    } else {
      _cachedMaps.add(updatedMap);
    }
    
    await _persistData();
    return updatedMap;
  }

  @override
  Future<void> deleteMap(String id) async {
    await _init();
    _cachedMaps.removeWhere((m) => m.id == id);
    await _persistData();
  }
}
