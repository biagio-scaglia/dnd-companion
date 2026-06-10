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
    debugPrint('🚀 [CompendiumController] Inizializzazione dati Compendio...');
    _state = CompendiumState.loadingFirstTime;
    notifyListeners();
    
    try {
      // Inizializza/Aggiorna da asset se necessario
      await repository.initializeCompendium();
      
      // Carica i dati in memoria
      await _fetchItemsSilently();
      _state = CompendiumState.loaded;
    } catch (e) {
      debugPrint('Errore inizializzazione compendio: $e');
      _state = CompendiumState.hardError;
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
      // Forza la re-inizializzazione locale e ricarica i dati
      await repository.forceSync();
      await _fetchItemsSilently();
      _state = CompendiumState.loaded;
    } catch (e) {
      debugPrint('Errore durante il refresh: $e');
      _state = CompendiumState.loaded;
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
      debugPrint('🔍 [CompendiumController] Eseguo fetch degli elementi con filtro: letter=${_filter.selectedLetter}, category=${_filter.selectedCategory}, favoritesOnly=${_filter.showOnlyFavorites}');
      _items = await repository.fetchItems(_filter);
      debugPrint('✅ [CompendiumController] Fetch completato. Trovati ${_items.length} elementi.');
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

