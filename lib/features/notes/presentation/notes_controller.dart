import 'package:flutter/material.dart';
import '../domain/models/note.dart';
import '../domain/models/session.dart';
import '../domain/models/attachment.dart';
import '../domain/models/character.dart';
import '../domain/repositories/notes_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesController extends ChangeNotifier {
  final NotesRepository repository;
  final _uuid = const Uuid();

  NotesController({required this.repository}) {
    loadData();
  }

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  List<CampaignSession> _sessions = [];
  List<CampaignSession> get sessions => _sessions;

  List<Attachment> _attachments = [];
  List<Attachment> get attachments => _attachments;

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await repository.getNotes();
      _sessions = await repository.getSessions();
      _attachments = await repository.getAttachments();
      _characters = await repository.getCharacters();
    } catch (e) {
      debugPrint('Error loading notes data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Notes Actions ---
  Future<void> createNote(String title, String content, {bool isImportant = false, String? sessionId, List<String>? tags}) async {
    final note = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      date: DateTime.now(),
      isImportant: isImportant,
      sessionId: sessionId,
      tags: tags ?? [],
    );
    await repository.addNote(note);
    await loadData();
  }

  Future<void> toggleNoteImportance(Note note) async {
    final updated = note.copyWith(isImportant: !note.isImportant);
    await repository.updateNote(updated);
    await loadData();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    await loadData();
  }

  // --- Sessions Actions ---
  Future<void> createSession(String title, String summary, DateTime date) async {
    final session = CampaignSession(
      id: _uuid.v4(),
      title: title,
      summary: summary,
      date: date,
    );
    await repository.addSession(session);
    await loadData();
  }

  Future<void> deleteSession(String id) async {
    await repository.deleteSession(id);
    await loadData();
  }

  // --- Characters Actions ---
  Future<void> createCharacter(String name, String characterClass, int level, {String? notes}) async {
    final character = Character(
      id: _uuid.v4(),
      name: name,
      characterClass: characterClass,
      level: level,
      notes: notes,
    );
    await repository.addCharacter(character);
    await loadData();
  }

  Future<void> deleteCharacter(String id) async {
    await repository.deleteCharacter(id);
    await loadData();
  }

  // --- Attachments Actions ---
  Future<void> addAttachmentReference(String fileName, String filePath, String type) async {
    final attachment = Attachment(
      id: _uuid.v4(),
      fileName: fileName,
      filePath: filePath,
      type: type,
      dateAdded: DateTime.now(),
    );
    await repository.addAttachment(attachment);
    await loadData();
  }

  Future<void> pickAttachment() async {
    try {
      final result = await FilePicker.pickFiles();
      
      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);
        final fileName = result.files.single.name;
        
        // Copia il file nella cartella dell'app per persistenza
        final appDir = await getApplicationDocumentsDirectory();
        final savedFile = await pickedFile.copy('${appDir.path}/$fileName');
        
        String type = 'file';
        if (fileName.endsWith('.jpg') || fileName.endsWith('.png') || fileName.endsWith('.jpeg')) {
          type = 'image';
        } else if (fileName.endsWith('.pdf')) {
          type = 'pdf';
        }
        
        await addAttachmentReference(fileName, savedFile.path, type);
      }
    } catch (e) {
      debugPrint('Errore nel picking del file: $e');
    }
  }

  Future<void> deleteAttachment(String id) async {
    try {
      final attachment = _attachments.firstWhere((a) => a.id == id);
      final file = File(attachment.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Errore nell\'eliminazione del file fisico: $e');
    }
    
    await repository.deleteAttachment(id);
    await loadData();
  }

  // --- Data Management ---
  Future<String> exportData() async {
    return await repository.exportData();
  }

  Future<void> importData(String json) async {
    await repository.importData(json);
    await loadData();
  }

  // --- Getters for Home Summaries ---
  Note? get latestImportantNote {
    try {
      return _notes.where((n) => n.isImportant).reduce((a, b) => a.date.isAfter(b.date) ? a : b);
    } catch (_) {
      return null;
    }
  }

  CampaignSession? get latestSession {
    try {
      return _sessions.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
    } catch (_) {
      return null;
    }
  }

  Attachment? get latestAttachment {
    try {
      return _attachments.reduce((a, b) => a.dateAdded.isAfter(b.dateAdded) ? a : b);
    } catch (_) {
      return null;
    }
  }
}
