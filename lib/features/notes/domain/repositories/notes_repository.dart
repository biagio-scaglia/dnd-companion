import '../models/note.dart';
import '../models/session.dart';
import '../models/attachment.dart';
import '../models/character.dart';

abstract class NotesRepository {
  // Notes
  Future<List<Note>> getNotes();
  Future<Note> addNote(Note note);
  Future<Note> updateNote(Note note);
  Future<void> deleteNote(String id);

  // Sessions
  Future<List<CampaignSession>> getSessions();
  Future<CampaignSession> addSession(CampaignSession session);
  Future<CampaignSession> updateSession(CampaignSession session);
  Future<void> deleteSession(String id);

  // Attachments
  Future<List<Attachment>> getAttachments();
  Future<Attachment> addAttachment(Attachment attachment);
  Future<void> deleteAttachment(String id);

  // Characters
  Future<List<Character>> getCharacters();
  Future<Character> addCharacter(Character character);
  Future<Character> updateCharacter(Character character);
  Future<void> deleteCharacter(String id);

  // Data Management
  Future<String> exportData();
  Future<void> importData(String json);
}
