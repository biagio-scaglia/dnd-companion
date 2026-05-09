import 'map_element.dart';

class MapLayer {
  final String id;
  String name;
  bool isVisible;
  List<MapElement> elements;

  MapLayer({
    required this.id,
    required this.name,
    this.isVisible = true,
    List<MapElement>? elements,
  }) : elements = elements ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isVisible': isVisible,
      'elements': elements.map((e) => e.toJson()).toList(),
    };
  }

  factory MapLayer.fromJson(Map<String, dynamic> json) {
    return MapLayer(
      id: json['id'],
      name: json['name'],
      isVisible: json['isVisible'] ?? true,
      elements: (json['elements'] as List?)
              ?.map((e) => MapElement.fromJson(e))
              .toList() ??
          [],
    );
  }

  MapLayer copyWith({
    String? id,
    String? name,
    bool? isVisible,
    List<MapElement>? elements,
  }) {
    return MapLayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      elements: elements ?? List.from(this.elements),
    );
  }
}
