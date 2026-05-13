import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/compendium_item.dart';

class DndApiClient {
  static const String baseUrl = 'https://www.dnd5eapi.co/api';

  Future<List<CompendiumItem>> fetchAllItems() async {
    final List<CompendiumItem> allItems = [];

    try {
      final graphqlUrl = Uri.parse('https://www.dnd5eapi.co/graphql');
      final response = await _post(
        graphqlUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'query': '''
          query { 
            spells { index name school { name } } 
            magicItems { index name }
            monsters { index name size type alignment hit_points armor_class { value } }
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
        
        // Fetch classi e razze tramite REST
        await _fetchClassesAndRacesRest(allItems);
      } else {
        throw Exception('GraphQL error: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore fetch GraphQL: $e');
      
      // Fallback su REST API standard se GraphQL fallisce
      try {
        // 1. Spells
        final spellsResp = await _get(Uri.parse('https://www.dnd5eapi.co/api/spells'));
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
        final monstersResp = await _get(Uri.parse('https://www.dnd5eapi.co/api/monsters'));
        if (monstersResp.statusCode == 200) {
          final data = json.decode(monstersResp.body);
          final results = data['results'] as List<dynamic>? ?? [];
          for (var r in results) {
            allItems.add(CompendiumItem(
              id: r['index'],
              name: r['name'],
              type: CompendiumItemType.monster,
              shortDescription: '__TAP_TO_LOAD_DETAILS__',
              description: '__TAP_TO_LOAD_DETAILS__',
              metaInfo: 'Mostro',
            ));
          }
        }

        // 3. Magic Items
        final itemsResp = await _get(Uri.parse('https://www.dnd5eapi.co/api/magic-items'));
        if (itemsResp.statusCode == 200) {
          final data = json.decode(itemsResp.body);
          final results = data['results'] as List<dynamic>? ?? [];
          for (var r in results) {
            allItems.add(CompendiumItem(
              id: r['index'],
              name: r['name'],
              type: CompendiumItemType.item,
              shortDescription: '__TAP_TO_LOAD_DETAILS__',
              description: '__TAP_TO_LOAD_DETAILS__',
              metaInfo: 'Oggetto',
            ));
          }
        }

        // Fetch classi e razze tramite REST
        await _fetchClassesAndRacesRest(allItems);
      } catch (e2) {
        print('Errore fallback REST: $e2');
      }
    }

    return allItems;
  }

  Future<void> _fetchClassesAndRacesRest(List<CompendiumItem> allItems) async {
    try {
      // 4. Classes
      final classesResp = await _get(Uri.parse('https://www.dnd5eapi.co/api/classes'));
      if (classesResp.statusCode == 200) {
        final data = json.decode(classesResp.body);
        final results = data['results'] as List<dynamic>? ?? [];
        
        for (var r in results) {
          allItems.add(CompendiumItem(
            id: r['index'],
            name: r['name'],
            type: CompendiumItemType.characterClass,
            shortDescription: '__TAP_TO_LOAD_DETAILS__',
            description: '__TAP_TO_LOAD_DETAILS__',
            metaInfo: 'Classe',
          ));
        }
      }

      // 5. Races
      final racesResp = await _get(Uri.parse('https://www.dnd5eapi.co/api/races'));
      if (racesResp.statusCode == 200) {
        final data = json.decode(racesResp.body);
        final results = data['results'] as List<dynamic>? ?? [];
        
        for (var r in results) {
          allItems.add(CompendiumItem(
            id: r['index'],
            name: r['name'],
            type: CompendiumItemType.race,
            shortDescription: '__TAP_TO_LOAD_DETAILS__',
            description: '__TAP_TO_LOAD_DETAILS__',
            metaInfo: 'Razza',
          ));
        }
      }
    } catch (e) {
      print('Errore fetch classi/razze: $e');
    }
  }

  CompendiumItem _parseGraphqlItem(dynamic item, CompendiumItemType type) {
    String fullDesc = '';
    String shortDesc = '';

    if (type == CompendiumItemType.monster) {
      final size = item['size'] ?? '';
      final mType = item['type'] ?? '';
      final alignment = item['alignment'] ?? '';
      final hp = item['hit_points']?.toString() ?? '?';
      final acList = item['armor_class'] as List?;
      final ac = acList != null && acList.isNotEmpty ? acList[0]['value']?.toString() ?? '?' : '?';
      
      shortDesc = '$size $mType, $alignment. HP: $hp. AC: $ac';
      fullDesc = '__DETAILS_NOT_AVAILABLE_OFFLINE__\n\n$shortDesc';
    } else {
      if (item['desc'] != null) {
        if (item['desc'] is List) {
          fullDesc = (item['desc'] as List).join('\n\n');
        } else {
          fullDesc = item['desc'].toString();
        }
        
        shortDesc = fullDesc.replaceAll('\n', ' ').trim();
        if (shortDesc.length > 80) {
          shortDesc = '${shortDesc.substring(0, 80)}...';
        }
      } else if (type == CompendiumItemType.spell) {
        final school = item['school']?['name'] ?? 'Unknown';
        shortDesc = 'School: $school.';
        fullDesc = '__TAP_TO_LOAD_DETAILS__';
      } else {
        shortDesc = 'Tocca per caricare i dettagli.';
        fullDesc = '__TAP_TO_LOAD_DETAILS__';
      }
    }

    if (fullDesc.trim().isEmpty) fullDesc = 'Nessuna descrizione trovata.';

    return CompendiumItem(
      id: item['index'],
      name: item['name'],
      type: type,
      shortDescription: shortDesc.isEmpty ? 'Nessuna anteprima.' : shortDesc,
      description: fullDesc,
      metaInfo: type == CompendiumItemType.spell 
          ? 'Spell (${item['school']?['name'] ?? ''})' 
          : (type == CompendiumItemType.monster ? 'Mostro' : 
            (type == CompendiumItemType.item ? 'Oggetto' : 
            (type == CompendiumItemType.characterClass ? 'Classe' : 'Razza'))),
    );
  }

  Future<String> fetchItemDescription(CompendiumItemType type, String id) async {
    String category = '';
    switch (type) {
      case CompendiumItemType.spell: category = 'spells'; break;
      case CompendiumItemType.monster: category = 'monsters'; break;
      case CompendiumItemType.item: category = 'magic-items'; break;
      case CompendiumItemType.characterClass: category = 'classes'; break;
      case CompendiumItemType.race: category = 'races'; break;
    }

    final response = await _get(Uri.parse('$baseUrl/$category/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (type == CompendiumItemType.monster) {
        return _formatMonsterDetails(data);
      }
      if (type == CompendiumItemType.characterClass) {
        return _formatClassDetails(data);
      }
      if (type == CompendiumItemType.race) {
        return _formatRaceDetails(data);
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

  String _formatClassDetails(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    
    buffer.writeln('HIT DIE: d${data['hit_die']}');
    buffer.writeln('');
    
    if (data['proficiency_choices'] != null) {
      buffer.writeln('PROFICIENCY CHOICES');
      for (var choice in data['proficiency_choices']) {
        final choose = choice['choose'];
        final fromObj = choice['from'];
        String from = '';
        if (fromObj != null && fromObj['options'] != null) {
          final options = fromObj['options'] as List;
          from = options.map((e) => e['item']?['name'] ?? '').where((e) => e.isNotEmpty).join(', ');
        }
        buffer.writeln('• Choose $choose from: $from');
      }
      buffer.writeln('');
    }
    
    if (data['proficiencies'] != null) {
      buffer.writeln('PROFICIENCIES');
      final profs = (data['proficiencies'] as List).map((e) => e['name']).join(', ');
      buffer.writeln('• $profs');
      buffer.writeln('');
    }
    
    if (data['saving_throws'] != null) {
      buffer.writeln('SAVING THROWS');
      final saves = (data['saving_throws'] as List).map((e) => e['name']).join(', ');
      buffer.writeln('• $saves');
      buffer.writeln('');
    }
    
    if (data['subclasses'] != null) {
      buffer.writeln('SUBCLASSES');
      final subs = (data['subclasses'] as List).map((e) => e['name']).join(', ');
      buffer.writeln('• $subs');
      buffer.writeln('');
    }
    
    return buffer.toString();
  }

  String _formatRaceDetails(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    
    buffer.writeln('SPEED: ${data['speed']} ft');
    buffer.writeln('SIZE: ${data['size']}');
    buffer.writeln('SIZE DESCRIPTION: ${data['size_description']}');
    buffer.writeln('');
    
    if (data['ability_bonuses'] != null) {
      buffer.writeln('ABILITY BONUSES');
      for (var bonus in data['ability_bonuses']) {
        final score = bonus['ability_score']?['name'] ?? '?';
        final val = bonus['bonus'];
        buffer.writeln('• $score: +$val');
      }
      buffer.writeln('');
    }
    
    if (data['traits'] != null) {
      buffer.writeln('TRAITS');
      final traits = (data['traits'] as List).map((e) => e['name']).join(', ');
      buffer.writeln('• $traits');
      buffer.writeln('');
    }
    
    if (data['languages'] != null) {
      buffer.writeln('LANGUAGES');
      final langs = (data['languages'] as List).map((e) => e['name']).join(', ');
      buffer.writeln('• $langs');
      buffer.writeln('');
    }
    
    if (data['subraces'] != null) {
      buffer.writeln('SUBRACES');
      final subs = (data['subraces'] as List).map((e) => e['name']).join(', ');
      buffer.writeln('• $subs');
      buffer.writeln('');
    }
    
    return buffer.toString();
  }

  Future<http.Response> _get(Uri url) {
    return http.get(url).timeout(const Duration(seconds: 10));
  }

  Future<http.Response> _post(Uri url, {Map<String, String>? headers, Object? body}) {
    return http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 10));
  }
}

