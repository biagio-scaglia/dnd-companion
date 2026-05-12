import 'compendium_item.dart';

class CompendiumFilter {
  final String query;
  final CompendiumItemType? selectedCategory;
  final bool showOnlyFavorites;
  final String? selectedLetter;

  const CompendiumFilter({
    this.query = '',
    this.selectedCategory,
    this.showOnlyFavorites = false,
    this.selectedLetter,
  });

  CompendiumFilter copyWith({
    String? query,
    CompendiumItemType? selectedCategory,
    bool? showOnlyFavorites,
    String? selectedLetter,
    bool clearCategory = false,
    bool clearLetter = false,
  }) {
    return CompendiumFilter(
      query: query ?? this.query,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
      selectedLetter: clearLetter ? null : (selectedLetter ?? this.selectedLetter),
    );
  }
}
