import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final Uuid _uuid = const Uuid();

  /// Copia un file nella cartella sicura dell'app per renderlo persistente e offline-first.
  Future<File> storeFile(File file) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final attachmentsDirectory = Directory(path.join(documentsDirectory.path, 'attachments'));
    
    // Crea la cartella se non esiste
    if (!await attachmentsDirectory.exists()) {
      await attachmentsDirectory.create(recursive: true);
    }
    
    // Genera un nome unico per evitare sovrascritture
    final fileExtension = path.extension(file.path);
    final fileName = '${_uuid.v4()}$fileExtension';
    final storedPath = path.join(attachmentsDirectory.path, fileName);
    
    // Copia il file
    return file.copy(storedPath);
  }

  /// Elimina un file dallo storage dell'app.
  Future<void> deleteFile(String storedPath) async {
    try {
      final file = File(storedPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Errore durante l\'eliminazione del file: $e');
    }
  }

  /// Verifica se un file esiste.
  Future<bool> fileExists(String storedPath) async {
    return File(storedPath).exists();
  }
}
