class Character {
  final String id;
  final String name;
  final String characterClass;
  final int level;
  final String? imagePath;
  final String? notes;

  Character({
    required this.id,
    required this.name,
    required this.characterClass,
    required this.level,
    this.imagePath,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'characterClass': characterClass,
      'level': level,
      'imagePath': imagePath,
      'notes': notes,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      characterClass: json['characterClass'],
      level: json['level'],
      imagePath: json['imagePath'],
      notes: json['notes'],
    );
  }
}
