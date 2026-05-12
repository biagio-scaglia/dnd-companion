import 'package:flutter/material.dart';
import '../domain/models/compendium_item.dart';
import '../domain/models/compendium_filter.dart';
import '../domain/repositories/compendium_repository.dart';

class CompendiumController extends ChangeNotifier {
  final CompendiumRepository repository;

  CompendiumController({required this.repository}) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await repository.syncWithApi();
    _fetchItems();
  }

  // Stato interno
  List<CompendiumItem> _items = [];
  List<CompendiumItem> get items => _items;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  CompendiumFilter _filter = const CompendiumFilter();
  CompendiumFilter get filter => _filter;

  // --- Azioni ---

  void setLetter(String? letter) {
    if (_filter.selectedLetter == letter) return;
    _filter = _filter.copyWith(selectedLetter: letter, clearLetter: letter == null);
    _fetchItems();
  }

  void setCategory(CompendiumItemType category) {
    if (_filter.selectedCategory == category) return;
    _filter = _filter.copyWith(selectedCategory: category);
    _fetchItems();
  }

  void toggleCategory(CompendiumItemType category) {
    if (_filter.selectedCategory == category) {
      _filter = _filter.copyWith(clearCategory: true);
    } else {
      _filter = _filter.copyWith(selectedCategory: category);
    }
    _fetchItems();
  }

  void toggleFavoritesOnly() {
    _filter = _filter.copyWith(showOnlyFavorites: !_filter.showOnlyFavorites);
    _fetchItems();
  }

  Future<void> toggleFavoriteStatus(String id) async {
    try {
      final updatedItem = await repository.toggleFavorite(id);
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        
        // Se stiamo guardando solo i preferiti e lo rimuoviamo, nascondiamolo
        if (_filter.showOnlyFavorites && !updatedItem.isFavorite) {
          _items.removeAt(index);
        }
        
        notifyListeners();
      }
    } catch (e) {
      // Gestione errori silente (o log) per il momento
    }
  }

  Future<void> _fetchItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Recupera dal DB (la sincronizzazione avviene solo all'avvio)
      _items = await repository.fetchItems(_filter);
    } catch (e) {
      print('Errore fetch items da controller: $e');
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCustomItem(CompendiumItem item) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await repository.addCustomItem(item);
      await _fetchItems();
    } catch (e) {
      print('Errore aggiunta elemento custom: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

