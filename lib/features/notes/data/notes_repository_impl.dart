import 'dart:convert';
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
    
    // Inizializziamo con dati mock in formato JSON
    _jsonData = jsonEncode({
      'sessions': [
        {
          'id': 'session-1',
          'title': 'Il Lamento della Banshee',
          'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          'summary': 'Il party ha affrontato gli spiriti nelle cripte e trovato il medaglione antico.',
        }
      ],
      'notes': [
        {
          'id': 'note-1',
          'title': 'Medaglione Antico',
          'content': 'Abbiamo trovato un medaglione nelle cripte. Emette una debole luce viola quando ci si avvicina a un non-morto.',
          'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          'isImportant': true,
          'sessionId': 'session-1',
          'tags': ['Oggetti', 'Mistero'],
        }
      ],
      'attachments': [],
      'characters': []
    });
    _initialized = true;
  }

  Map<String, dynamic> _getData() {
    return jsonDecode(_jsonData);
  }

  void _saveData(Map<String, dynamic> data) {
    _jsonData = jsonEncode(data);
  }

  // --- Notes ---
  @override
  Future<List<Note>> getNotes() async {
    await _init();
    final data = _getData();
    final list = data['notes'] as List;
    return list.map((e) => Note.fromJson(e)).toList();
  }

  @override
  Future<Note> addNote(Note note) async {
    await _init();
    final data = _getData();
    final list = data['notes'] as List;
    list.add(note.toJson());
    _saveData(data);
    return note;
  }

  @override
  Future<Note> updateNote(Note note) async {
    await _init();
    final data = _getData();
    final list = data['notes'] as List;
    final index = list.indexWhere((e) => e['id'] == note.id);
    if (index != -1) {
      list[index] = note.toJson();
      _saveData(data);
    }
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    await _init();
    final data = _getData();
    final list = data['notes'] as List;
    list.removeWhere((e) => e['id'] == id);
    _saveData(data);
  }

  // --- Sessions ---
  @override
  Future<List<CampaignSession>> getSessions() async {
    await _init();
    final data = _getData();
    final list = data['sessions'] as List;
    return list.map((e) => CampaignSession.fromJson(e)).toList();
  }

  @override
  Future<CampaignSession> addSession(CampaignSession session) async {
    await _init();
    final data = _getData();
    final list = data['sessions'] as List;
    list.add(session.toJson());
    _saveData(data);
    return session;
  }

  @override
  Future<CampaignSession> updateSession(CampaignSession session) async {
    await _init();
    final data = _getData();
    final list = data['sessions'] as List;
    final index = list.indexWhere((e) => e['id'] == session.id);
    if (index != -1) {
      list[index] = session.toJson();
      _saveData(data);
    }
    return session;
  }

  @override
  Future<void> deleteSession(String id) async {
    await _init();
    final data = _getData();
    final list = data['sessions'] as List;
    list.removeWhere((e) => e['id'] == id);
    _saveData(data);
  }

  // --- Attachments ---
  @override
  Future<List<Attachment>> getAttachments() async {
    await _init();
    final data = _getData();
    final list = data['attachments'] as List;
    return list.map((e) => Attachment.fromJson(e)).toList();
  }

  @override
  Future<Attachment> addAttachment(Attachment attachment) async {
    await _init();
    final data = _getData();
    final list = data['attachments'] as List;
    list.add(attachment.toJson());
    _saveData(data);
    return attachment;
  }

  @override
  Future<void> deleteAttachment(String id) async {
    await _init();
    final data = _getData();
    final list = data['attachments'] as List;
    list.removeWhere((e) => e['id'] == id);
    _saveData(data);
  }

  // --- Characters ---
  @override
  Future<List<Character>> getCharacters() async {
    await _init();
    final data = _getData();
    final list = data['characters'] as List?;
    if (list == null) return [];
    return list.map((e) => Character.fromJson(e)).toList();
  }

  @override
  Future<Character> addCharacter(Character character) async {
    await _init();
    final data = _getData();
    final list = data['characters'] as List;
    list.add(character.toJson());
    _saveData(data);
    return character;
  }

  @override
  Future<Character> updateCharacter(Character character) async {
    await _init();
    final data = _getData();
    final list = data['characters'] as List;
    final index = list.indexWhere((e) => e['id'] == character.id);
    if (index != -1) {
      list[index] = character.toJson();
      _saveData(data);
    }
    return character;
  }

  @override
  Future<void> deleteCharacter(String id) async {
    await _init();
    final data = _getData();
    final list = data['characters'] as List;
    list.removeWhere((e) => e['id'] == id);
    _saveData(data);
  }
}
