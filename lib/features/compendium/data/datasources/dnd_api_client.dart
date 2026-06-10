import '../../domain/models/compendium_item.dart';

@Deprecated("Use local asset data cached in SQLite instead of calling external APIs")
class DndApiClient {
  Future<List<CompendiumItem>> fetchAllItems() async {
    return const [];
  }

  Future<Map<String, String>> fetchItemDescription(CompendiumItemType type, String id) async {
    return const {};
  }
}

