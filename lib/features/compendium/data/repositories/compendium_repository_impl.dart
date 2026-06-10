import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/models/compendium_filter.dart';
import '../../domain/models/compendium_item.dart';
import '../../domain/repositories/compendium_repository.dart';

class CompendiumRepositoryImpl implements CompendiumRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // In-memory cache to make page filtering instantaneous and avoid database reads on each filter change
  List<CompendiumItem>? _cachedItems;

  @override
  Future<void> initializeCompendium() async {
    try {
      // 1. Carica la versione salvata dell'asset importato
      final lastSyncVersion = await _dbHelper.getLastSync('compendium_asset_version');

      // 2. Carica l'asset JSON
      debugPrint('📖 [CompendiumRepository] Caricamento asset compendium.json...');
      final jsonString = await rootBundle.loadString('lib/assets/compendium.json');
      final data = json.decode(jsonString);
      
      final metadata = data['metadata'] as Map<String, dynamic>? ?? {};
      final assetVersionStr = metadata['lastSyncAt'] as String? ?? '1.0';
      
      // Converte la stringa timestamp in epoch per confronto rapido
      int assetVersion;
      try {
        assetVersion = DateTime.parse(assetVersionStr).millisecondsSinceEpoch;
      } catch (_) {
        assetVersion = 1; // Fallback se non è una data valida
      }

      // Se non è mai stato importato, o se l'asset è più recente di quello già importato
      if (lastSyncVersion == null || assetVersion > lastSyncVersion) {
        debugPrint('🔄 [CompendiumRepository] Importazione/Aggiornamento compendio in corso...');
        final itemsList = data['items'] as List<dynamic>? ?? [];
        
        final items = itemsList.map((r) {
          final typeStr = r['type'];
          CompendiumItemType type = CompendiumItemType.item;
          if (typeStr == 'spell') type = CompendiumItemType.spell;
          if (typeStr == 'monster') type = CompendiumItemType.monster;
          if (typeStr == 'class') type = CompendiumItemType.characterClass;
          if (typeStr == 'race') type = CompendiumItemType.race;

          return CompendiumItem(
            id: r['id'],
            name: r['name'],
            type: type,
            shortDescription: r['shortDescription'] ?? '',
            description: r['description'] ?? '',
            metaInfo: r['metaInfo'] ?? '',
          );
        }).toList();

        // Preserva i preferiti caricando quelli esistenti dal database
        final maps = await _dbHelper.queryAllItems();
        final existingItems = {
          for (var m in maps) m['id'] as String: CompendiumItem.fromMap(m)
        };

        final db = await _dbHelper.database;
        await db.transaction((txn) async {
          final batch = txn.batch();
          for (var item in items) {
            final existing = existingItems[item.id];
            final toInsert = existing != null 
                ? item.copyWith(isFavorite: existing.isFavorite) 
                : item;

            batch.insert(
              DatabaseHelper.tableCompendium,
              toInsert.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          await batch.commit(noResult: true);
        });

        // Salva la versione dell'asset importata
        await _dbHelper.setLastSync('compendium_asset_version', assetVersion);
        
        // Svuota cache
        _cachedItems = null;
        debugPrint('✅ [CompendiumRepository] Importazione completata! ${items.length} elementi.');
      } else {
        debugPrint('✅ [CompendiumRepository] Compendio locale già aggiornato alla versione: $assetVersionStr');
      }
    } catch (e) {
      debugPrint('🔴 [CompendiumRepository] Errore inizializzazione compendio locale: $e');
    }
  }

  @override
  Future<void> syncWithApi() async {
    await initializeCompendium();
  }

  @override
  Future<void> forceSync() async {
    await initializeCompendium();
  }

  @override
  Future<List<CompendiumItem>> fetchItems(CompendiumFilter filter) async {
    List<CompendiumItem> allItems;
    if (_cachedItems != null) {
      allItems = _cachedItems!;
    } else {
      final maps = await _dbHelper.queryAllItems();
      allItems = maps.map((map) => CompendiumItem.fromMap(map)).toList();
      _cachedItems = allItems;
    }

    var results = List<CompendiumItem>.from(allItems);

    // Filtro per categoria
    if (filter.selectedCategory != null) {
      results = results.where((item) => item.type == filter.selectedCategory).toList();
    }

    // Filtro per favoriti
    if (filter.showOnlyFavorites) {
      results = results.where((item) => item.isFavorite).toList();
    }

    // Filtro per lettera iniziale
    if (filter.selectedLetter != null) {
      final l = filter.selectedLetter!.toLowerCase();
      results = results.where((item) {
        return item.name.toLowerCase().startsWith(l);
      }).toList();
    }

    return results;
  }

  @override
  Future<CompendiumItem> toggleFavorite(String id) async {
    final item = await getItemById(id);
    if (item == null) throw Exception('Item not found');

    final updatedItem = item.copyWith(isFavorite: !item.isFavorite);
    await _dbHelper.updateItem(updatedItem.toMap());

    // Aggiorna l'elemento direttamente nella cache in memoria
    if (_cachedItems != null) {
      final index = _cachedItems!.indexWhere((element) => element.id == id);
      if (index != -1) {
        _cachedItems![index] = updatedItem;
      }
    }

    return updatedItem;
  }

  @override
  Future<CompendiumItem?> getItemById(String id) async {
    // Prova prima la cache in memoria
    if (_cachedItems != null) {
      try {
        return _cachedItems!.firstWhere((element) => element.id == id);
      } catch (_) {}
    }

    // Altrimenti eseguiamo una query mirata a singola riga su SQLite
    final map = await _dbHelper.queryItemById(id);
    if (map != null) {
      return CompendiumItem.fromMap(map);
    }
    return null;
  }

  @override
  Future<void> addCustomItem(CompendiumItem item) async {
    final customItem = item.copyWith(
      id: item.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : item.id,
      isCustom: true,
    );
    await _dbHelper.insertItem(customItem.toMap());
    
    // Invalida la cache in memoria per includere l'elemento personalizzato
    _cachedItems = null;
  }
}
