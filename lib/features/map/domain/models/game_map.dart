import 'map_layer.dart';

class GameMap {
  final String id;
  String name;
  int width;
  int height;
  List<MapLayer> layers;
  final DateTime createdAt;
  DateTime updatedAt;

  GameMap({
    required this.id,
    required this.name,
    this.width = 30, // Default 30x30 tiles
    this.height = 30,
    List<MapLayer>? layers,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : layers = layers ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'height': height,
      'layers': layers.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory GameMap.fromJson(Map<String, dynamic> json) {
    return GameMap(
      id: json['id'],
      name: json['name'],
      width: json['width'] ?? 30,
      height: json['height'] ?? 30,
      layers: (json['layers'] as List?)
              ?.map((e) => MapLayer.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  GameMap copyWith({
    String? id,
    String? name,
    int? width,
    int? height,
    List<MapLayer>? layers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameMap(
      id: id ?? this.id,
      name: name ?? this.name,
      width: width ?? this.width,
      height: height ?? this.height,
      layers: layers ?? List.from(this.layers),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
