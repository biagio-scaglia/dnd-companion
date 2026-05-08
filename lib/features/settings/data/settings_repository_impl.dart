import 'dart:convert';
import '../domain/models/settings_model.dart';
import '../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  String _jsonData = '{}';
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    
    // Inizializziamo con valori di default
    _jsonData = jsonEncode(SettingsModel().toJson());
    _initialized = true;
  }

  @override
  Future<SettingsModel> getSettings() async {
    await _init();
    final data = jsonDecode(_jsonData);
    return SettingsModel.fromJson(data);
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await _init();
    _jsonData = jsonEncode(settings.toJson());
  }
}
