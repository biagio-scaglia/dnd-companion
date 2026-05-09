enum CharacterStatus { attivo, morto, ritirato, npcAlly }

class Character {
  final String id;
  final String name;
  final String? playerName;
  final String race;
  final String characterClass;
  final String? subclass;
  final int level;
  final String? alignment;
  final String? background;
  final CharacterStatus status;
  final String? campaign;
  final String? currentLocation;
  final String? goal;
  final String? traits;
  final String? ideals;
  final String? bonds;
  final String? flaws;
  final String? shortDescription;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Character({
    required this.id,
    required this.name,
    this.playerName,
    required this.race,
    required this.characterClass,
    this.subclass,
    required this.level,
    this.alignment,
    this.background,
    required this.status,
    this.campaign,
    this.currentLocation,
    this.goal,
    this.traits,
    this.ideals,
    this.bonds,
    this.flaws,
    this.shortDescription,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Character copyWith({
    String? id,
    String? name,
    String? playerName,
    String? race,
    String? characterClass,
    String? subclass,
    int? level,
    String? alignment,
    String? background,
    CharacterStatus? status,
    String? campaign,
    String? currentLocation,
    String? goal,
    String? traits,
    String? ideals,
    String? bonds,
    String? flaws,
    String? shortDescription,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      playerName: playerName ?? this.playerName,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      subclass: subclass ?? this.subclass,
      level: level ?? this.level,
      alignment: alignment ?? this.alignment,
      background: background ?? this.background,
      status: status ?? this.status,
      campaign: campaign ?? this.campaign,
      currentLocation: currentLocation ?? this.currentLocation,
      goal: goal ?? this.goal,
      traits: traits ?? this.traits,
      ideals: ideals ?? this.ideals,
      bonds: bonds ?? this.bonds,
      flaws: flaws ?? this.flaws,
      shortDescription: shortDescription ?? this.shortDescription,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'playerName': playerName,
      'race': race,
      'characterClass': characterClass,
      'subclass': subclass,
      'level': level,
      'alignment': alignment,
      'background': background,
      'status': status.toString(),
      'campaign': campaign,
      'currentLocation': currentLocation,
      'goal': goal,
      'traits': traits,
      'ideals': ideals,
      'bonds': bonds,
      'flaws': flaws,
      'shortDescription': shortDescription,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      playerName: json['playerName'] as String?,
      race: json['race'] as String? ?? 'Sconosciuta',
      characterClass: json['characterClass'] as String? ?? 'Sconosciuta',
      subclass: json['subclass'] as String?,
      level: json['level'] as int? ?? 1,
      alignment: json['alignment'] as String?,
      background: json['background'] as String?,
      status: json['status'] != null 
          ? CharacterStatus.values.firstWhere((e) => e.toString() == json['status'], orElse: () => CharacterStatus.attivo)
          : CharacterStatus.attivo,
      campaign: json['campaign'] as String?,
      currentLocation: json['currentLocation'] as String?,
      goal: json['goal'] as String?,
      traits: json['traits'] as String?,
      ideals: json['ideals'] as String?,
      bonds: json['bonds'] as String?,
      flaws: json['flaws'] as String?,
      shortDescription: json['shortDescription'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }
}
