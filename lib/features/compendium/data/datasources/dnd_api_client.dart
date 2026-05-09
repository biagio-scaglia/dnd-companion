import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/compendium_item.dart';

class DndApiClient {
  static const String baseUrl = 'https://www.dnd5eapi.co/api';

  Future<List<CompendiumItem>> fetchAllItems() async {
    final List<CompendiumItem> allItems = [];

    try {
      final graphqlUrl = Uri.parse('https://www.dnd5eapi.co/graphql');
      final response = await http.post(
        graphqlUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'query': '''
          { 
            spells(limit: 500) { index name desc } 
            magicItems(limit: 500) { index name desc }
            monsters(limit: 500) { index name size type alignment hit_points }
          }
          '''
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          final spells = data['data']['spells'] as List<dynamic>? ?? [];
          final items = data['data']['magicItems'] as List<dynamic>? ?? [];
          final monsters = data['data']['monsters'] as List<dynamic>? ?? [];

          allItems.addAll(spells.map((s) => _parseGraphqlItem(s, CompendiumItemType.spell)));
          allItems.addAll(items.map((i) => _parseGraphqlItem(i, CompendiumItemType.item)));
          allItems.addAll(monsters.map((m) => _parseGraphqlItem(m, CompendiumItemType.monster)));
        }
      }
    } catch (e) {
      print('Errore fetch GraphQL: $e');
      
      // Fallback su REST API standard se GraphQL fallisce
      try {
        // 1. Spells
        final spellsResp = await http.get(Uri.parse('https://www.dnd5eapi.co/api/spells'));
        if (spellsResp.statusCode == 200) {
          final data = json.decode(spellsResp.body);
          final results = data['results'] as List<dynamic>? ?? [];
          for (var r in results) {
            allItems.add(CompendiumItem(
              id: r['index'],
              name: r['name'],
              type: CompendiumItemType.spell,
              shortDescription: 'Tocca per caricare i dettagli.',
              description: 'Tocca per caricare i dettagli.',
              metaInfo: 'Incantesimo',
            ));
          }
        }

        // 2. Monsters
        final monstersResp = await http.get(Uri.parse('https://www.dnd5eapi.co/api/monsters'));
        if (monstersResp.statusCode == 200) {
          final data = json.decode(monstersResp.body);
          final results = data['results'] as List<dynamic>? ?? [];
          for (var r in results) {
            allItems.add(CompendiumItem(
              id: r['index'],
              name: r['name'],
              type: CompendiumItemType.monster,
              shortDescription: 'Tocca per caricare i dettagli.',
              description: 'Tocca per caricare i dettagli.',
              metaInfo: 'Mostro',
            ));
          }
        }

        // 3. Magic Items
        final itemsResp = await http.get(Uri.parse('https://www.dnd5eapi.co/api/magic-items'));
        if (itemsResp.statusCode == 200) {
          final data = json.decode(itemsResp.body);
          final results = data['results'] as List<dynamic>? ?? [];
          for (var r in results) {
            allItems.add(CompendiumItem(
              id: r['index'],
              name: r['name'],
              type: CompendiumItemType.item,
              shortDescription: 'Tocca per caricare i dettagli.',
              description: 'Tocca per caricare i dettagli.',
              metaInfo: 'Oggetto',
            ));
          }
        }
      } catch (e2) {
        print('Errore fallback REST: $e2');
      }
    }

    return allItems;
  }

  CompendiumItem _parseGraphqlItem(dynamic item, CompendiumItemType type) {
    String fullDesc = '';
    String shortDesc = '';

    if (type == CompendiumItemType.monster) {
      final size = item['size'] ?? '';
      final mType = item['type'] ?? '';
      final alignment = item['alignment'] ?? '';
      final hp = item['hit_points']?.toString() ?? '?';
      
      shortDesc = '$size $mType, $alignment. HP: $hp';
      fullDesc = 'Dettagli non disponibili offline per questo elemento.\n\n$shortDesc';
    } else {
      if (item['desc'] != null) {
        if (item['desc'] is List) {
          fullDesc = (item['desc'] as List).join('\n\n');
        } else {
          fullDesc = item['desc'].toString();
        }
      }
      
      shortDesc = fullDesc.replaceAll('\n', ' ').trim();
      if (shortDesc.length > 80) {
        shortDesc = '${shortDesc.substring(0, 80)}...';
      }
    }

    if (fullDesc.trim().isEmpty) fullDesc = 'Nessuna descrizione trovata.';

    return CompendiumItem(
      id: item['index'],
      name: item['name'],
      type: type,
      shortDescription: shortDesc.isEmpty ? 'Nessuna anteprima.' : shortDesc,
      description: fullDesc,
      metaInfo: type == CompendiumItemType.spell ? 'Incantesimo' : (type == CompendiumItemType.monster ? 'Mostro' : 'Oggetto'),
    );
  }

  Future<String> fetchItemDescription(CompendiumItemType type, String id) async {
    String category = '';
    switch (type) {
      case CompendiumItemType.spell: category = 'spells'; break;
      case CompendiumItemType.monster: category = 'monsters'; break;
      case CompendiumItemType.item: category = 'magic-items'; break;
    }

    final response = await http.get(Uri.parse('$baseUrl/$category/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (type == CompendiumItemType.monster) {
        return _formatMonsterDetails(data);
      }

      if (data['desc'] != null) {
        if (data['desc'] is List) return (data['desc'] as List).join('\n\n');
        return data['desc'].toString();
      }

      return 'Nessuna descrizione dettagliata trovata.';
    } else {
      throw Exception('Failed to fetch details');
    }
  }

  String _formatMonsterDetails(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    
    buffer.writeln('ARMOR CLASS: ${data['armor_class']?[0]?['value'] ?? '?'}');
    buffer.writeln('HIT POINTS: ${data['hit_points']}');
    
    if (data['speed'] != null) {
      buffer.writeln('SPEED: ${data['speed'].toString().replaceAll('{', '').replaceAll('}', '')}');
    }
    buffer.writeln('');
    
    buffer.writeln('STR: ${data['strength']} | DEX: ${data['dexterity']} | CON: ${data['constitution']} | INT: ${data['intelligence']} | WIS: ${data['wisdom']} | CHA: ${data['charisma']}');
    buffer.writeln('');

    if (data['special_abilities'] != null) {
      buffer.writeln('ABILITIES');
      for (var ab in data['special_abilities']) {
        buffer.writeln('• ${ab['name']}: ${ab['desc']}');
        buffer.writeln('');
      }
    }

    if (data['actions'] != null) {
      buffer.writeln('ACTIONS');
      for (var ac in data['actions']) {
        buffer.writeln('• ${ac['name']}: ${ac['desc']}');
        buffer.writeln('');
      }
    }

    return buffer.toString();
  }
}

