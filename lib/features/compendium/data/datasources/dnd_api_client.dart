import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/compendium_item.dart';

class DndApiClient {
  static const String baseUrl = 'https://www.dnd5eapi.co/api';

  Future<List<CompendiumItem>> fetchAllItems() async {
    final allItems = <CompendiumItem>[];

    try {
      // 1. Fetch Spells e Monsters dal nuovo Backend su Render
      final response = await _get(Uri.parse('https://backend-vellum.onrender.com/api/compendium'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Se il backend sta ancora sincronizzando
        if (data is Map && data['status'] == 'syncing') {
          print('Backend in fase di sincronizzazione. Riprova tra poco.');
        } else {
          final items = data['items'] as List<dynamic>? ?? [];
          for (var r in items) {
            final typeStr = r['type'];
            CompendiumItemType type = CompendiumItemType.item;
            if (typeStr == 'spell') type = CompendiumItemType.spell;
            if (typeStr == 'monster') type = CompendiumItemType.monster;
            if (typeStr == 'class') type = CompendiumItemType.characterClass;
            if (typeStr == 'race') type = CompendiumItemType.race;
            
            allItems.add(CompendiumItem(
              id: r['id'],
              name: r['name'],
              type: type,
              shortDescription: r['shortDescription'] ?? '',
              description: r['description'] ?? '',
              metaInfo: r['metaInfo'] ?? '',
            ));
          }
        }
      }

      // Rimosso fetchClassesAndRacesRest perché ora arrivano dal backend!
    } catch (e) {
      print('Errore fetch REST all items: $e');
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

  Future<Map<String, String>> fetchItemDescription(CompendiumItemType type, String id) async {
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
      
      String description = '';
      String shortDescription = 'Tocca per caricare i dettagli.';
      String metaInfo = '';

      if (type == CompendiumItemType.monster) {
        final size = data['size'] ?? '';
        final mType = data['type'] ?? '';
        final alignment = data['alignment'] ?? '';
        final hp = data['hit_points']?.toString() ?? '?';
        final acList = data['armor_class'] as List?;
        final ac = acList != null && acList.isNotEmpty ? acList[0]['value']?.toString() ?? '?' : '?';
        
        shortDescription = '$size $mType, $alignment. HP: $hp. AC: $ac';
        description = _formatMonsterDetails(data);
        metaInfo = 'Mostro ($mType)';
      } else if (type == CompendiumItemType.spell) {
        final school = data['school']?['name'] ?? 'Unknown';
        description = data['desc'] != null ? (data['desc'] is List ? (data['desc'] as List).join('\n\n') : data['desc'].toString()) : 'Nessuna descrizione.';
        shortDescription = 'School: $school.';
        metaInfo = 'Spell ($school)';
      } else if (type == CompendiumItemType.characterClass) {
        description = _formatClassDetails(data);
        shortDescription = 'Tocca per caricare i dettagli.';
        metaInfo = 'Classe';
      } else if (type == CompendiumItemType.race) {
        description = _formatRaceDetails(data);
        shortDescription = 'Tocca per caricare i dettagli.';
        metaInfo = 'Razza';
      } else {
        if (data['desc'] != null) {
          if (data['desc'] is List) description = (data['desc'] as List).join('\n\n');
          else description = data['desc'].toString();
        } else {
          description = 'Nessuna descrizione dettagliata trovata.';
        }
        shortDescription = 'Tocca per caricare i dettagli.';
        metaInfo = 'Oggetto';
      }

      return {
        'description': description,
        'shortDescription': shortDescription,
        'metaInfo': metaInfo,
      };
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

