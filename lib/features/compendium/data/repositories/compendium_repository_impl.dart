import 'package:flutter/foundation.dart' show debugPrint;
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/models/compendium_filter.dart';
import '../../domain/models/compendium_item.dart';
import '../../domain/repositories/compendium_repository.dart';
import '../datasources/dnd_api_client.dart';

class CompendiumRepositoryImpl implements CompendiumRepository {
  final DndApiClient _apiClient = DndApiClient();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  static const _ttlDays = 7;

  // In-memory cache to make page filtering instantaneous and avoid database reads on each filter change
  List<CompendiumItem>? _cachedItems;

  @override
  Future<void> syncWithApi() async {
    await _syncAll(force: false);
  }

  @override
  Future<void> forceSync() async {
    await _syncAll(force: true);
  }

  Future<void> _syncAll({required bool force}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final ttlMillis = _ttlDays * 24 * 60 * 60 * 1000;

    try {
      final isStale = await _isStale('compendium_data', now, ttlMillis);
      
      if (force || isStale) {
        debugPrint('Sync con API in corso...');
        final items = await _apiClient.fetchAllItems();
        
        // 1. Carica tutti i record esistenti dal database una volta sola per velocizzare i controlli esistenti (O(1) lookup invece di O(N) query ripetute)
        final maps = await _dbHelper.queryAllItems();
        final existingItems = {
          for (var m in maps) m['id'] as String: CompendiumItem.fromMap(m)
        };
        
        // 2. Utilizza una transazione ed un batch SQLite per caricare tutti gli elementi in pochissimi millisecondi invece di svariati secondi
        final db = await _dbHelper.database;
        await db.transaction((txn) async {
          final batch = txn.batch();
          
          for (var item in items) {
            final existing = existingItems[item.id];
            
            final toInsert = existing != null 
                ? item.copyWith(
                    isFavorite: existing.isFavorite,
                  ) 
                : item;
                
            batch.insert(
              DatabaseHelper.tableCompendium,
              toInsert.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          
          await batch.commit(noResult: true);
        });

        await _dbHelper.setLastSync('compendium_data', now);
        await _dbHelper.setLastSync('classes', now);
        await _dbHelper.setLastSync('races', now);

        // Svuota la cache in memoria per forzare il ricaricamento dei nuovi dati
        _cachedItems = null;
        debugPrint('Sync con API completato con successo. Inseriti ${items.length} elementi.');
      } else {
        debugPrint('Cache valida, salto il sync.');
      }
    } catch (e) {
      debugPrint('Errore durante la sincronizzazione con l\'API: $e');
    }
  }

  Future<bool> _isStale(String dataset, int now, int ttlMillis) async {
    final lastSync = await _dbHelper.getLastSync(dataset);
    if (lastSync == null) return true;
    return (now - lastSync) > ttlMillis;
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
