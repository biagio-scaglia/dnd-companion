class DndRace {
  final String index;
  final String name;
  final int speed;
  final String size;
  final String sizeDescription;
  final List<Map<String, dynamic>> abilityBonuses;
  final List<Map<String, dynamic>> traits;
  final List<Map<String, dynamic>> languages;
  final List<Map<String, dynamic>> subraces;

  DndRace({
    required this.index,
    required this.name,
    required this.speed,
    required this.size,
    required this.sizeDescription,
    required this.abilityBonuses,
    required this.traits,
    required this.languages,
    required this.subraces,
  });

  factory DndRace.fromJson(Map<String, dynamic> json) {
    return DndRace(
      index: json['index'] ?? '',
      name: json['name'] ?? '',
      speed: json['speed'] ?? 0,
      size: json['size'] ?? '',
      sizeDescription: json['size_description'] ?? '',
      abilityBonuses: (json['ability_bonuses'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      traits: (json['traits'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      subraces: (json['subraces'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}
