import 'package:flutter/material.dart';
import '../domain/models/compendium_item.dart';
import '../domain/models/compendium_filter.dart';
import '../domain/repositories/compendium_repository.dart';

enum CompendiumState {
  loadingFirstTime,
  showingCached,
  refreshingInBackground,
  hardError,
  loaded
}

class CompendiumController extends ChangeNotifier {
  final CompendiumRepository repository;

  CompendiumController({required this.repository}) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    // 1. Carica subito i dati locali
    _state = CompendiumState.loadingFirstTime;
    notifyListeners();
    
    await _fetchItemsSilently();
    
    if (_items.isEmpty) {
      _state = CompendiumState.loadingFirstTime;
    } else {
      _state = CompendiumState.showingCached;
    }
    notifyListeners();

    // 2. Avvia il sync in background
    try {
      if (_items.isNotEmpty) {
        _state = CompendiumState.refreshingInBackground;
        notifyListeners();
      }
      
      await repository.syncWithApi();
      
      // Ricarica i dati dopo il sync
      await _fetchItemsSilently();
      _state = CompendiumState.loaded;
    } catch (e) {
      debugPrint('Errore sync in background: $e');
      if (_items.isEmpty) {
        _state = CompendiumState.hardError;
      } else {
        _state = CompendiumState.showingCached; // Resta su cached se il sync fallisce
      }
    } finally {
      notifyListeners();
    }
  }

  // Stato interno
  List<CompendiumItem> _items = [];
  List<CompendiumItem> get items => _items;

  CompendiumState _state = CompendiumState.loadingFirstTime;
  CompendiumState get state => _state;

  bool get isLoading => _state == CompendiumState.loadingFirstTime;

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

  Future<void> refresh() async {
    _state = CompendiumState.refreshingInBackground;
    notifyListeners();
    try {
      await repository.forceSync();
      await _fetchItemsSilently();
      _state = CompendiumState.loaded;
    } catch (e) {
      debugPrint('Errore durante il refresh: $e');
      _state = CompendiumState.showingCached;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _fetchItems() async {
    // Non cambiamo lo stato se stiamo già mostrando la cache o rinfrescando
    if (_state != CompendiumState.showingCached && _state != CompendiumState.refreshingInBackground) {
      _state = CompendiumState.loadingFirstTime;
      notifyListeners();
    }

    await _fetchItemsSilently();
    
    if (_state == CompendiumState.loadingFirstTime) {
      _state = _items.isEmpty ? CompendiumState.loadingFirstTime : CompendiumState.loaded;
    }
    notifyListeners();
  }

  Future<void> _fetchItemsSilently() async {
    try {
      _items = await repository.fetchItems(_filter);
    } catch (e) {
      debugPrint('Errore fetch items da controller: $e');
      _items = [];
    }
  }

  Future<void> addCustomItem(CompendiumItem item) async {
    _state = CompendiumState.loadingFirstTime;
    notifyListeners();
    
    try {
      await repository.addCustomItem(item);
      await _fetchItems();
    } catch (e) {
      debugPrint('Errore aggiunta elemento custom: $e');
      _state = CompendiumState.hardError;
    } finally {
      if (_state != CompendiumState.hardError) {
        _state = CompendiumState.loaded;
      }
      notifyListeners();
    }
  }
}

