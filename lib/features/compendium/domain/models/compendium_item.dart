enum CompendiumItemType { monster, spell, item }

class CompendiumItem {
  final String id;
  final String name;
  final CompendiumItemType type;
  final String shortDescription;
  final String description;
  final String? metaInfo; // es: "Lvl 3 Evocazione", "Oggetto Raro", "Sfida 5"
  final bool isFavorite;

  const CompendiumItem({
    required this.id,
    required this.name,
    required this.type,
    required this.shortDescription,
    required this.description,
    this.metaInfo,
    this.isFavorite = false,
  });

  CompendiumItem copyWith({
    String? id,
    String? name,
    CompendiumItemType? type,
    String? shortDescription,
    String? description,
    String? metaInfo,
    bool? isFavorite,
  }) {
    return CompendiumItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      metaInfo: metaInfo ?? this.metaInfo,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
