enum CompendiumItemType { monster, spell, item }

class CompendiumItem {
  final String id;
  final String name;
  final CompendiumItemType type;
  final String shortDescription;
  final String description;
  final String? metaInfo;
  final bool isFavorite;
  final bool isCustom;

  const CompendiumItem({
    required this.id,
    required this.name,
    required this.type,
    required this.shortDescription,
    required this.description,
    this.metaInfo,
    this.isFavorite = false,
    this.isCustom = false,
  });

  CompendiumItem copyWith({
    String? id,
    String? name,
    CompendiumItemType? type,
    String? shortDescription,
    String? description,
    String? metaInfo,
    bool? isFavorite,
    bool? isCustom,
  }) {
    return CompendiumItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      metaInfo: metaInfo ?? this.metaInfo,
      isFavorite: isFavorite ?? this.isFavorite,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'shortDescription': shortDescription,
      'description': description,
      'metaInfo': metaInfo,
      'isFavorite': isFavorite ? 1 : 0,
      'isCustom': isCustom ? 1 : 0,
    };
  }

  factory CompendiumItem.fromMap(Map<String, dynamic> map) {
    return CompendiumItem(
      id: map['id'],
      name: map['name'],
      type: CompendiumItemType.values.firstWhere((e) => e.name == map['type']),
      shortDescription: map['shortDescription'],
      description: map['description'],
      metaInfo: map['metaInfo'],
      isFavorite: map['isFavorite'] == 1,
      isCustom: map['isCustom'] == 1,
    );
  }
}
