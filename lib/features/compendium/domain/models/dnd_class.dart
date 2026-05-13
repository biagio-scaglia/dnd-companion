class DndClass {
  final String index;
  final String name;
  final int hitDie;
  final List<Map<String, dynamic>> proficiencyChoices;
  final List<Map<String, dynamic>> proficiencies;
  final List<Map<String, dynamic>> savingThrows;
  final List<Map<String, dynamic>> subclasses;

  DndClass({
    required this.index,
    required this.name,
    required this.hitDie,
    required this.proficiencyChoices,
    required this.proficiencies,
    required this.savingThrows,
    required this.subclasses,
  });

  factory DndClass.fromJson(Map<String, dynamic> json) {
    return DndClass(
      index: json['index'] ?? '',
      name: json['name'] ?? '',
      hitDie: json['hit_die'] ?? 0,
      proficiencyChoices: (json['proficiency_choices'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      proficiencies: (json['proficiencies'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      savingThrows: (json['saving_throws'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      subclasses: (json['subclasses'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}
