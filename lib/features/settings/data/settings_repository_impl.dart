import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/settings_model.dart';
import '../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _key = 'app_settings';

  @override
  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr != null) {
      try {
        return SettingsModel.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        print('Errore parsing settings: $e');
      }
    }
    return SettingsModel(); // Default
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
