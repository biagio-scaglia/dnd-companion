import '../../domain/models/compendium_filter.dart';
import '../../domain/models/compendium_item.dart';
import '../../domain/repositories/compendium_repository.dart';
import '../datasources/compendium_seed_data.dart';

class CompendiumRepositoryImpl implements CompendiumRepository {
  // Simulazione di un database locale in RAM
  List<CompendiumItem> _localCache = [];

  CompendiumRepositoryImpl() {
    _localCache = List.from(compendiumSeedData);
  }

  @override
  Future<List<CompendiumItem>> fetchItems(CompendiumFilter filter) async {
    // Simuliamo un minimo di latenza (database offline / file read)
    await Future.delayed(const Duration(milliseconds: 250));

    var results = _localCache;

    // Filtro per categoria
    if (filter.selectedCategory != null) {
      results = results.where((item) => item.type == filter.selectedCategory).toList();
    }

    // Filtro per favoriti
    if (filter.showOnlyFavorites) {
      results = results.where((item) => item.isFavorite).toList();
    }

    // Filtro per query testuale (case-insensitive)
    if (filter.query.trim().isNotEmpty) {
      final q = filter.query.toLowerCase();
      results = results.where((item) {
        return item.name.toLowerCase().contains(q) || 
               item.shortDescription.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }

  @override
  Future<CompendiumItem> toggleFavorite(String id) async {
    final index = _localCache.indexWhere((item) => item.id == id);
    if (index == -1) throw Exception('Item not found');

    final updatedItem = _localCache[index].copyWith(isFavorite: !_localCache[index].isFavorite);
    _localCache[index] = updatedItem;

    return updatedItem;
  }

  @override
  Future<CompendiumItem?> getItemById(String id) async {
    try {
      return _localCache.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
