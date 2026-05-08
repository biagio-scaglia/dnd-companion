import '../models/compendium_item.dart';
import '../models/compendium_filter.dart';

abstract class CompendiumRepository {
  Future<List<CompendiumItem>> fetchItems(CompendiumFilter filter);
  Future<CompendiumItem> toggleFavorite(String id);
  Future<CompendiumItem?> getItemById(String id);
}
