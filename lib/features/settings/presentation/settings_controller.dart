import 'package:flutter/material.dart';
import '../domain/models/settings_model.dart';
import '../domain/repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepository repository;

  SettingsController({required this.repository}) {
    loadSettings();
  }

  SettingsModel _settings = SettingsModel();
  SettingsModel get settings => _settings;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _settings = await repository.getSettings();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(SettingsModel newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  // Metodi rapidi per i toggle
  Future<void> toggleDarkTheme(bool value) async {
    await updateSettings(_settings.copyWith(darkTheme: value));
  }

  Future<void> setAccentColor(String color) async {
    await updateSettings(_settings.copyWith(accentColor: color));
  }

  Future<void> toggleAnimations(bool value) async {
    await updateSettings(_settings.copyWith(animationsEnabled: value));
  }

  Future<void> toggleHaptic(bool value) async {
    await updateSettings(_settings.copyWith(hapticFeedback: value));
  }

  Future<void> toggleConfirmDestructive(bool value) async {
    await updateSettings(_settings.copyWith(confirmDestructiveActions: value));
  }

  Future<void> toggleCompactMode(bool value) async {
    await updateSettings(_settings.copyWith(compactMode: value));
  }

  Future<void> setLocale(String locale) async {
    await updateSettings(_settings.copyWith(locale: locale));
  }
}
