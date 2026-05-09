import 'map_tile_type.dart';

class MapElement {
  final String id;
  int gridX;
  int gridY;
  MapTileType type;
  String? emoji; // New field for placeable emojis

  MapElement({
    required this.id,
    required this.gridX,
    required this.gridY,
    required this.type,
    this.emoji,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gridX': gridX,
      'gridY': gridY,
      'type': type.name,
      'emoji': emoji,
    };
  }

  factory MapElement.fromJson(Map<String, dynamic> json) {
    return MapElement(
      id: json['id'],
      gridX: json['gridX'],
      gridY: json['gridY'],
      type: MapTileType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MapTileType.floorStone, // fallback
      ),
      emoji: json['emoji'],
    );
  }

  MapElement copyWith({
    String? id,
    int? gridX,
    int? gridY,
    MapTileType? type,
    String? emoji,
  }) {
    return MapElement(
      id: id ?? this.id,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
      type: type ?? this.type,
      emoji: emoji ?? this.emoji,
    );
  }
}
