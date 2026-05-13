import '../../../../core/database/database_helper.dart';
import '../../domain/models/compendium_filter.dart';
import '../../domain/models/compendium_item.dart';
import '../../domain/repositories/compendium_repository.dart';
import '../datasources/dnd_api_client.dart';

class CompendiumRepositoryImpl implements CompendiumRepository {
  final DndApiClient _apiClient = DndApiClient();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  static const _ttlDays = 7;

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
        print('Inizio sincronizzazione compendio...');
        final items = await _apiClient.fetchAllItems();
        
        // Salva gli elementi nel DB (rimpiazza quelli esistenti per aggiornare)
        for (var item in items) {
          final existing = await getItemById(item.id);
          final toInsert = existing != null 
              ? item.copyWith(
                  isFavorite: existing.isFavorite,
                  description: (existing.description != '__TAP_TO_LOAD_DETAILS__' && existing.description.isNotEmpty) 
                      ? existing.description 
                      : item.description,
                  metaInfo: (existing.metaInfo != null && existing.metaInfo!.isNotEmpty && existing.metaInfo != 'Spell' && existing.metaInfo != 'Mostro' && existing.metaInfo != 'Oggetto')
                      ? existing.metaInfo
                      : item.metaInfo,
                ) 
              : item;
          await _dbHelper.insertItem(toInsert.toMap());
        }
        
        await _dbHelper.setLastSync('compendium_data', now);
        // Prepariamo le chiavi separate per il futuro
        await _dbHelper.setLastSync('classes', now);
        await _dbHelper.setLastSync('races', now);
        print('Sincronizzazione completata.');
      } else {
        print('Cache valida, salto il sync.');
      }
    } catch (e) {
      print('Errore durante la sincronizzazione con l\'API: $e');
      // In offline-first, l'errore di sync viene ignorato e usiamo la cache
    }
  }

  Future<bool> _isStale(String dataset, int now, int ttlMillis) async {
    final lastSync = await _dbHelper.getLastSync(dataset);
    if (lastSync == null) return true;
    return (now - lastSync) > ttlMillis;
  }

  @override
  Future<List<CompendiumItem>> fetchItems(CompendiumFilter filter) async {
    final maps = await _dbHelper.queryAllItems();
    var results = maps.map((map) => CompendiumItem.fromMap(map)).toList();

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

    return updatedItem;
  }

  @override
  Future<CompendiumItem?> getItemById(String id) async {
    final maps = await _dbHelper.queryAllItems();
    try {
      final map = maps.firstWhere((element) => element['id'] == id);
      return CompendiumItem.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addCustomItem(CompendiumItem item) async {
    // Generiamo un ID univoco se non lo ha (usiamo uuid, oppure datetime)
    final customItem = item.copyWith(
      id: item.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : item.id,
      isCustom: true,
    );
    await _dbHelper.insertItem(customItem.toMap());
  }
}
