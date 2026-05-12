import 'package:flutter/material.dart';
import '../domain/models/note.dart';
import '../domain/models/session.dart';
import '../domain/models/attachment.dart';
import '../domain/models/character.dart';
import '../domain/repositories/notes_repository.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/file_picker_service.dart';
import '../../../core/services/storage_service.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

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

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _hasError = false;
      _notes = await repository.getNotes();
      _sessions = await repository.getSessions();
      _attachments = await repository.getAttachments();
      _characters = await repository.getCharacters();
    } catch (e) {
      _hasError = true;
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
  Future<void> createSession(CampaignSession session) async {
    await repository.addSession(session);
    await loadData();
  }

  Future<void> updateSession(CampaignSession session) async {
    await repository.updateSession(session);
    await loadData();
  }

  Future<void> deleteSession(String id) async {
    await repository.deleteSession(id);
    await loadData();
  }

  // --- Characters Actions ---
  Future<void> createCharacter(Character character) async {
    await repository.addCharacter(character);
    await loadData();
  }

  Future<void> updateCharacter(Character character) async {
    await repository.updateCharacter(character);
    await loadData();
  }

  Future<void> deleteCharacter(String id) async {
    await repository.deleteCharacter(id);
    await loadData();
  }


  // --- Attachments Actions ---
  Future<void> pickAndAddAttachment({
    required String linkedEntityId,
    required String linkedEntityType,
  }) async {
    try {
      final filePicker = FilePickerService();
      final storageService = StorageService();

      final file = await filePicker.pickFile();
      if (file != null) {
        final storedFile = await storageService.storeFile(file);
        final fileName = path.basename(file.path);
        final ext = path.extension(file.path).replaceAll('.', '');
        
        String sourceType = 'file';
        if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext.toLowerCase())) {
          sourceType = 'image';
        } else if (ext.toLowerCase() == 'pdf') {
          sourceType = 'pdf';
        }

        final attachment = Attachment(
          id: _uuid.v4(),
          linkedEntityId: linkedEntityId,
          linkedEntityType: linkedEntityType,
          fileName: fileName,
          storedPath: storedFile.path,
          extension: ext,
          fileSize: await file.length(),
          createdAt: DateTime.now(),
          sourceType: sourceType,
        );

        await repository.addAttachment(attachment);
        await loadData();
      }
    } catch (e) {
      debugPrint('Errore durante l\'aggiunta dell\'allegato: $e');
    }
  }

  Future<void> deleteAttachment(String id) async {
    try {
      final attachment = _attachments.firstWhere((a) => a.id == id);
      final file = File(attachment.storedPath);
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
      return _sessions.reduce((a, b) => a.realDate.isAfter(b.realDate) ? a : b);
    } catch (_) {
      return null;
    }
  }

  Attachment? get latestAttachment {
    try {
      return _attachments.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
    } catch (_) {
      return null;
    }
  }
}
