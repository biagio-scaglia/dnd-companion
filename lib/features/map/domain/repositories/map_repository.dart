import '../models/game_map.dart';

abstract class MapRepository {
  Future<List<GameMap>> getMaps();
  Future<GameMap?> getMapById(String id);
  Future<GameMap> saveMap(GameMap map);
  Future<void> deleteMap(String id);
}
