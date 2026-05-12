import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../notes/domain/repositories/notes_repository.dart';
import '../../domain/models/backup_manifest.dart';
import '../../domain/models/backup_result.dart';
import '../../domain/models/import_preview.dart';
import 'archive_service.dart';

class BackupService {
  final NotesRepository repository;
  final ArchiveService archiveService;
  final Uuid _uuid = const Uuid();

  BackupService({
    required this.repository,
    required this.archiveService,
  });

  /// Esporta tutti i dati in un file .dndc
  Future<BackupResult> exportBackup(File targetFile) async {
    try {
      final tempDir = await Directory.systemTemp.createTemp('dnd_backup_');
      
      // 1. Ottieni i dati
      final jsonData = await repository.exportData();
      final dataFile = File(p.join(tempDir.path, 'data.json'));
      await dataFile.writeAsString(jsonData);

      // 2. Copia gli allegati
      final docDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(p.join(docDir.path, 'attachments'));
      final targetAttachmentsDir = Directory(p.join(tempDir.path, 'attachments'));
      
      if (await attachmentsDir.exists()) {
        await targetAttachmentsDir.create(recursive: true);
        await for (final file in attachmentsDir.list()) {
          if (file is File) {
            await file.copy(p.join(targetAttachmentsDir.path, p.basename(file.path)));
          }
        }
      }

      // 3. Crea il manifest
      final parsedData = jsonDecode(jsonData);
      final manifest = BackupManifest(
        formatVersion: 1,
        appVersion: '1.0.0',
        createdAt: DateTime.now(),
        deviceInfo: Platform.operatingSystem,
        counts: {
          'notes': (parsedData['notes'] as List?)?.length ?? 0,
          'sessions': (parsedData['sessions'] as List?)?.length ?? 0,
          'characters': (parsedData['characters'] as List?)?.length ?? 0,
          'attachments': (parsedData['attachments'] as List?)?.length ?? 0,
        },
      );
      
      final manifestFile = File(p.join(tempDir.path, 'manifest.json'));
      await manifestFile.writeAsString(jsonEncode(manifest.toJson()));

      // 4. Crea lo ZIP
      await archiveService.createArchive(tempDir, targetFile);

      // Pulizia
      await tempDir.delete(recursive: true);

      return BackupResult(success: true, message: 'Backup creato con successo!');
    } catch (e) {
      return BackupResult(success: false, message: 'Errore durante l\'export: $e');
    }
  }

  /// Genera una preview del backup senza importarlo
  Future<ImportPreview?> generatePreview(File zipFile) async {
    try {
      final tempDir = await Directory.systemTemp.createTemp('dnd_import_');
      await archiveService.extractArchive(zipFile, tempDir);

      final manifestFile = File(p.join(tempDir.path, 'manifest.json'));
      if (!await manifestFile.exists()) {
        await tempDir.delete(recursive: true);
        return null;
      }

      final manifestJson = jsonDecode(await manifestFile.readAsString());
      final manifest = BackupManifest.fromJson(manifestJson);

      await tempDir.delete(recursive: true);

      return ImportPreview(
        noteCount: manifest.counts['notes'] ?? 0,
        sessionCount: manifest.counts['sessions'] ?? 0,
        characterCount: manifest.counts['characters'] ?? 0,
        attachmentCount: manifest.counts['attachments'] ?? 0,
      );
    } catch (e) {
      return null;
    }
  }

  /// Importa i dati da un file .dndc
  Future<BackupResult> importBackup(File zipFile, {bool overwrite = false}) async {
    try {
      final tempDir = await Directory.systemTemp.createTemp('dnd_import_');
      await archiveService.extractArchive(zipFile, tempDir);

      final manifestFile = File(p.join(tempDir.path, 'manifest.json'));
      final dataFile = File(p.join(tempDir.path, 'data.json'));

      if (!await manifestFile.exists() || !await dataFile.exists()) {
        await tempDir.delete(recursive: true);
        return BackupResult(success: false, message: 'File di backup non valido o corrotto.');
      }

      final manifestJson = jsonDecode(await manifestFile.readAsString());
      final manifest = BackupManifest.fromJson(manifestJson);

      // Controllo versione
      if (manifest.formatVersion > 1) {
        await tempDir.delete(recursive: true);
        return BackupResult(success: false, message: 'Versione del formato non supportata. Aggiorna l\'app.');
      }

      final backupJsonData = await dataFile.readAsString();
      final backupData = jsonDecode(backupJsonData);

      final docDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(p.join(docDir.path, 'attachments'));
      final tempAttachmentsDir = Directory(p.join(tempDir.path, 'attachments'));

      if (overwrite) {
        // Sostituisci tutto
        await repository.importData(backupJsonData);
        
        // Sostituisci allegati
        if (await attachmentsDir.exists()) {
          await attachmentsDir.delete(recursive: true);
        }
        await attachmentsDir.create(recursive: true);
        
        if (await tempAttachmentsDir.exists()) {
          await for (final file in tempAttachmentsDir.list()) {
            if (file is File) {
              await file.copy(p.join(attachmentsDir.path, p.basename(file.path)));
            }
          }
        }
        
        await tempDir.delete(recursive: true);
        return BackupResult(success: true, message: 'Dati sovrascritti con successo!');
      } else {
        // Unisci i dati
        final currentJsonData = await repository.exportData();
        final currentData = jsonDecode(currentJsonData);

        final mergeResult = _mergeData(currentData, backupData);
        
        await repository.importData(jsonEncode(mergeResult.mergedData));

        // Copia allegati non esistenti
        await attachmentsDir.create(recursive: true);
        if (await tempAttachmentsDir.exists()) {
          await for (final file in tempAttachmentsDir.list()) {
            if (file is File) {
              final targetPath = p.join(attachmentsDir.path, p.basename(file.path));
              if (!await File(targetPath).exists()) {
                await file.copy(targetPath);
              }
            }
          }
        }

        await tempDir.delete(recursive: true);
        return BackupResult(
          success: true, 
          message: 'Dati uniti con successo!',
          mergeDetails: mergeResult.details,
        );
      }
    } catch (e) {
      return BackupResult(success: false, message: 'Errore durante l\'import: $e');
    }
  }

  _MergeResult _mergeData(Map<String, dynamic> current, Map<String, dynamic> backup) {
    final details = <String, int>{'ignored': 0, 'duplicated': 0};
    
    // Funzione helper per unire una lista
    List<dynamic> mergeList(String key) {
      final currentList = (current[key] as List?) ?? [];
      final backupList = (backup[key] as List?) ?? [];
      
      final currentMap = {for (var e in currentList) e['id']: e};
      final mergedList = List<dynamic>.from(currentList);

      for (final bItem in backupList) {
        final id = bItem['id'];
        final cItem = currentMap[id];

        if (cItem == null) {
          // Non esiste, aggiungi
          mergedList.add(bItem);
        } else {
          // Esiste, confronta contenuto
          final cJson = jsonEncode(cItem);
          final bJson = jsonEncode(bItem);

          if (cJson == bJson) {
            // Contenuto uguale, ignora
            details['ignored'] = (details['ignored'] ?? 0) + 1;
          } else {
            // Contenuto diverso, duplica con nuovo ID
            final newItem = Map<String, dynamic>.from(bItem);
            newItem['id'] = _uuid.v4();
            if (newItem.containsKey('title')) {
              newItem['title'] = '${newItem['title']} (Copia Importata)';
            }
            mergedList.add(newItem);
            details['duplicated'] = (details['duplicated'] ?? 0) + 1;
          }
        }
      }
      return mergedList;
    }

    final mergedData = {
      'notes': mergeList('notes'),
      'sessions': mergeList('sessions'),
      'characters': mergeList('characters'),
      'attachments': mergeList('attachments'),
    };

    return _MergeResult(mergedData, details);
  }
}

class _MergeResult {
  final Map<String, dynamic> mergedData;
  final Map<String, int> details;

  _MergeResult(this.mergedData, this.details);
}
