import 'package:flutter_test/flutter_test.dart';
import 'package:dnd/features/compendium/domain/models/compendium_item.dart';

void main() {
  test('CompendiumItem serialization and deserialization test', () {
    const item = CompendiumItem(
      id: 'acid-arrow',
      name: 'Acid Arrow',
      type: CompendiumItemType.spell,
      shortDescription: 'School: Evocation.',
      description: 'A shimmering green arrow streaks toward a target.',
      metaInfo: 'Spell (Evocation)',
      isFavorite: true,
      isCustom: false,
    );

    final map = item.toMap();
    expect(map['id'], 'acid-arrow');
    expect(map['type'], 'spell');
    expect(map['isFavorite'], 1);

    final item2 = CompendiumItem.fromMap(map);
    expect(item2.id, 'acid-arrow');
    expect(item2.type, CompendiumItemType.spell);
    expect(item2.isFavorite, true);
  });
}
