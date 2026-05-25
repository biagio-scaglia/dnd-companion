import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/note.dart';
import '../domain/models/session.dart';
import '../domain/models/attachment.dart';
import '../domain/models/character.dart';
import '../domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  String _jsonData = '{}';
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('dnd_data');

      if (savedData != null) {
        // BUG FIX 3: verifica che il JSON sia valido prima di usarlo
        try {
          jsonDecode(savedData);
          _jsonData = savedData;
        } catch (e) {
          debugPrint('⚠️ [NotesRepo] JSON corrotto in SharedPreferences, reset ai default: $e');
          _jsonData = _buildDefaultJson();
          await prefs.setString('dnd_data', _jsonData);
        }
      } else {
        // Prima installazione: dati di esempio
        _jsonData = _buildDefaultJson();
        await prefs.setString('dnd_data', _jsonData);
      }
    } catch (e) {
      // Anche SharedPreferences può fallire — fallback sicuro in memoria
      debugPrint('⚠️ [NotesRepo] Errore durante _init(), uso dati vuoti: $e');
      _jsonData = _buildEmptyJson();
    }

    _initialized = true;
  }

  /// JSON di default per la prima installazione
  String _buildDefaultJson() {
    return jsonEncode({
      'sessions': [],
      'notes': [],
      'attachments': [],
      'characters': [],
    });
  }

  /// JSON vuoto per fallback di emergenza
  String _buildEmptyJson() {
    return jsonEncode({
      'sessions': [],
      'notes': [],
      'attachments': [],
      'characters': [],
    });
  }

  // BUG FIX 3+6: parsing sicuro con recovery — mai crasha
  Map<String, dynamic> _getData() {
    try {
      final decoded = jsonDecode(_jsonData);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      debugPrint('⚠️ [NotesRepo] _jsonData non è una Map, reset.');
      return jsonDecode(_buildEmptyJson()) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('⚠️ [NotesRepo] _getData() parse error: $e, ritorno vuoto');
      return {'sessions': [], 'notes': [], 'attachments': [], 'characters': []};
    }
  }

  Future<void> _saveData(Map<String, dynamic> data) async {
    try {
      _jsonData = jsonEncode(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dnd_data', _jsonData);
    } catch (e) {
      debugPrint('⚠️ [NotesRepo] _saveData() error: $e');
    }
  }

  // --- Notes ---
  @override
  Future<List<Note>> getNotes() async {
    await _init();
    final data = _getData();
    // BUG FIX 6: cast sicuro con fallback a lista vuota
    final list = (data['notes'] as List?) ?? [];
    final result = <Note>[];
    for (final e in list) {
      try {
        result.add(Note.fromJson(e as Map<String, dynamic>));
      } catch (ex) {
        debugPrint('⚠️ [NotesRepo] Note.fromJson error su elemento: $ex');
      }
    }
    return result;
  }

  @override
  Future<Note> addNote(Note note) async {
    await _init();
    final data = _getData();
    final list = (data['notes'] as List?) ?? [];
    data['notes'] = list;
    list.add(note.toJson());
    await _saveData(data);
    return note;
  }

  @override
  Future<Note> updateNote(Note note) async {
    await _init();
    final data = _getData();
    final list = (data['notes'] as List?) ?? [];
    data['notes'] = list;
    final index = list.indexWhere((e) => e['id'] == note.id);
    if (index != -1) {
      list[index] = note.toJson();
      await _saveData(data);
    }
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    await _init();
    final data = _getData();
    final list = (data['notes'] as List?) ?? [];
    data['notes'] = list;
    list.removeWhere((e) => e['id'] == id);
    await _saveData(data);
  }

  // --- Sessions ---
  @override
  Future<List<CampaignSession>> getSessions() async {
    await _init();
    final data = _getData();
    final list = (data['sessions'] as List?) ?? [];
    final result = <CampaignSession>[];
    for (final e in list) {
      try {
        result.add(CampaignSession.fromJson(e as Map<String, dynamic>));
      } catch (ex) {
        debugPrint('⚠️ [NotesRepo] Session.fromJson error: $ex');
      }
    }
    return result;
  }

  @override
  Future<CampaignSession> addSession(CampaignSession session) async {
    await _init();
    final data = _getData();
    final list = (data['sessions'] as List?) ?? [];
    data['sessions'] = list;
    list.add(session.toJson());
    await _saveData(data);
    return session;
  }

  @override
  Future<CampaignSession> updateSession(CampaignSession session) async {
    await _init();
    final data = _getData();
    final list = (data['sessions'] as List?) ?? [];
    data['sessions'] = list;
    final index = list.indexWhere((e) => e['id'] == session.id);
    if (index != -1) {
      list[index] = session.toJson();
      await _saveData(data);
    }
    return session;
  }

  @override
  Future<void> deleteSession(String id) async {
    await _init();
    final data = _getData();
    final list = (data['sessions'] as List?) ?? [];
    data['sessions'] = list;
    list.removeWhere((e) => e['id'] == id);
    await _saveData(data);
  }

  // --- Attachments ---
  @override
  Future<List<Attachment>> getAttachments() async {
    await _init();
    final data = _getData();
    final list = (data['attachments'] as List?) ?? [];
    final result = <Attachment>[];
    for (final e in list) {
      try {
        result.add(Attachment.fromJson(e as Map<String, dynamic>));
      } catch (ex) {
        debugPrint('⚠️ [NotesRepo] Attachment.fromJson error: $ex');
      }
    }
    return result;
  }

  @override
  Future<Attachment> addAttachment(Attachment attachment) async {
    await _init();
    final data = _getData();
    final list = (data['attachments'] as List?) ?? [];
    data['attachments'] = list;
    list.add(attachment.toJson());
    await _saveData(data);
    return attachment;
  }

  @override
  Future<void> deleteAttachment(String id) async {
    await _init();
    final data = _getData();
    final list = (data['attachments'] as List?) ?? [];
    data['attachments'] = list;
    list.removeWhere((e) => e['id'] == id);
    await _saveData(data);
  }

  // --- Characters ---
  @override
  Future<List<Character>> getCharacters() async {
    await _init();
    final data = _getData();
    final list = (data['characters'] as List?) ?? [];
    final result = <Character>[];
    for (final e in list) {
      try {
        result.add(Character.fromJson(e as Map<String, dynamic>));
      } catch (ex) {
        debugPrint('⚠️ [NotesRepo] Character.fromJson error: $ex');
      }
    }
    return result;
  }

  @override
  Future<Character> addCharacter(Character character) async {
    await _init();
    final data = _getData();
    final list = (data['characters'] as List?) ?? [];
    data['characters'] = list;
    list.add(character.toJson());
    await _saveData(data);
    return character;
  }

  @override
  Future<Character> updateCharacter(Character character) async {
    await _init();
    final data = _getData();
    final list = (data['characters'] as List?) ?? [];
    data['characters'] = list;
    final index = list.indexWhere((e) => e['id'] == character.id);
    if (index != -1) {
      list[index] = character.toJson();
      await _saveData(data);
    }
    return character;
  }

  @override
  Future<void> deleteCharacter(String id) async {
    await _init();
    final data = _getData();
    final list = (data['characters'] as List?) ?? [];
    data['characters'] = list;
    list.removeWhere((e) => e['id'] == id);
    await _saveData(data);
  }

  @override
  Future<String> exportData() async {
    await _init();
    return _jsonData;
  }

  @override
  Future<void> importData(String json) async {
    await _init();
    try {
      final parsed = jsonDecode(json);
      if (parsed is! Map<String, dynamic>) {
        debugPrint('⚠️ [NotesRepo] importData: JSON non è una Map, import annullato.');
        return;
      }
      _jsonData = json;
      await _saveData(parsed);
    } catch (e) {
      debugPrint('⚠️ [NotesRepo] importData error: $e');
    }
  }
}
