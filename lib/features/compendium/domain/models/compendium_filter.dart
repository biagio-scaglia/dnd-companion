import 'compendium_item.dart';

class CompendiumFilter {
  final String query;
  final CompendiumItemType? selectedCategory;
  final bool showOnlyFavorites;

  const CompendiumFilter({
    this.query = '',
    this.selectedCategory,
    this.showOnlyFavorites = false,
  });

  CompendiumFilter copyWith({
    String? query,
    CompendiumItemType? selectedCategory,
    bool? showOnlyFavorites,
    bool clearCategory = false,
  }) {
    return CompendiumFilter(
      query: query ?? this.query,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
    );
  }
}
