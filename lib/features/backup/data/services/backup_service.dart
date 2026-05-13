import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:archive/archive.dart';
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

  /// Esporta tutti i dati in bytes (ideale per il Web)
  Future<List<int>> exportBackupBytes() async {
    final archive = Archive();
    
    // 1. Ottieni i dati
    final jsonData = await repository.exportData();
    final jsonBytes = utf8.encode(jsonData);
    archive.addFile(ArchiveFile('data.json', jsonBytes.length, jsonBytes));

    // 2. Copia gli allegati (se possibile)
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(p.join(docDir.path, 'attachments'));
      
      if (await attachmentsDir.exists()) {
        await for (final file in attachmentsDir.list()) {
          if (file is File) {
            final bytes = await file.readAsBytes();
            final filename = p.basename(file.path);
            archive.addFile(ArchiveFile('attachments/$filename', bytes.length, bytes));
          }
        }
      }
    } catch (e) {
      print('Info: Impossibile leggere allegati su questa piattaforma: $e');
    }

    // 3. Crea il manifest
    final parsedData = jsonDecode(jsonData);
    final manifest = BackupManifest(
      formatVersion: 1,
      appVersion: '1.0.0',
      createdAt: DateTime.now(),
      deviceInfo: kIsWeb ? 'Web Browser' : Platform.operatingSystem,
      counts: {
        'notes': (parsedData['notes'] as List?)?.length ?? 0,
        'sessions': (parsedData['sessions'] as List?)?.length ?? 0,
        'characters': (parsedData['characters'] as List?)?.length ?? 0,
        'attachments': (parsedData['attachments'] as List?)?.length ?? 0,
      },
    );
    
    final manifestBytes = utf8.encode(jsonEncode(manifest.toJson()));
    archive.addFile(ArchiveFile('manifest.json', manifestBytes.length, manifestBytes));

    // 4. Crea lo ZIP
    final encoder = ZipEncoder();
    final zipBytes = encoder.encode(archive);
    if (zipBytes == null) {
      throw Exception('Failed to encode ZIP archive');
    }
    return zipBytes;
  }

  /// Esporta tutti i dati in un file .comp
  Future<BackupResult> exportBackup(File targetFile) async {
    try {
      final bytes = await exportBackupBytes();
      await targetFile.writeAsBytes(bytes);
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

  /// Genera una preview del backup dai bytes (per il Web)
  Future<ImportPreview?> generatePreviewFromBytes(Uint8List bytes) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      
      final manifestFile = archive.findFile('manifest.json');
      if (manifestFile == null) return null;

      final manifestJson = jsonDecode(utf8.decode(manifestFile.content));
      final manifest = BackupManifest.fromJson(manifestJson);

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

  /// Importa i dati da un file .comp
  Future<BackupResult> importBackup(File zipFile, {bool overwrite = false}) async {
    try {
      final tempDir = await Directory.systemTemp.createTemp('dnd_import_');
      await archiveService.extractArchive(zipFile, tempDir);

      final manifestFile = File(p.join(tempDir.path, 'manifest.json'));
      final dataFile = File(p.join(tempDir.path, 'data.json'));

      if (!await manifestFile.exists() || !await dataFile.exists()) {
        await tempDir.delete(recursive: true);
        return BackupResult(success: false, message: 'invalidBackupFile');
      }

      final manifestJson = jsonDecode(await manifestFile.readAsString());
      final manifest = BackupManifest.fromJson(manifestJson);

      // Controllo versione
      if (manifest.formatVersion > 1) {
        await tempDir.delete(recursive: true);
        return BackupResult(success: false, message: 'backupUnsupportedVersion');
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
        return BackupResult(success: true, message: 'backupOverwritten');
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
          message: 'backupMerged',
          mergeDetails: mergeResult.details,
        );
      }
    } catch (e) {
      return BackupResult(success: false, message: 'backupImportError|$e');
    }
  }

  /// Importa i dati dai bytes (per il Web)
  Future<BackupResult> importBackupFromBytes(Uint8List bytes, {bool overwrite = false}) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      
      final manifestFile = archive.findFile('manifest.json');
      final dataFile = archive.findFile('data.json');

      if (manifestFile == null || dataFile == null) {
        return BackupResult(success: false, message: 'invalidBackupFile');
      }

      final manifestJson = jsonDecode(utf8.decode(manifestFile.content));
      final manifest = BackupManifest.fromJson(manifestJson);

      // Controllo versione
      if (manifest.formatVersion > 1) {
        return BackupResult(success: false, message: 'backupUnsupportedVersion');
      }

      final backupJsonData = utf8.decode(dataFile.content);
      final backupData = jsonDecode(backupJsonData);

      final docDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(p.join(docDir.path, 'attachments'));

      if (overwrite) {
        await repository.importData(backupJsonData);
        
        // Sostituisci allegati
        if (await attachmentsDir.exists()) {
          await attachmentsDir.delete(recursive: true);
        }
        await attachmentsDir.create(recursive: true);
        
        for (final file in archive) {
          if (file.name.startsWith('attachments/') && file.isFile) {
            final filename = p.basename(file.name);
            final outFile = File(p.join(attachmentsDir.path, filename));
            await outFile.writeAsBytes(file.content as List<int>);
          }
        }
        
        return BackupResult(success: true, message: 'backupOverwritten');
      } else {
        final currentJsonData = await repository.exportData();
        final currentData = jsonDecode(currentJsonData);

        final mergeResult = _mergeData(currentData, backupData);
        
        await repository.importData(jsonEncode(mergeResult.mergedData));

        // Unisci allegati (sovrascrive se duplicati)
        if (!await attachmentsDir.exists()) {
          await attachmentsDir.create(recursive: true);
        }
        for (final file in archive) {
          if (file.name.startsWith('attachments/') && file.isFile) {
            final filename = p.basename(file.name);
            final outFile = File(p.join(attachmentsDir.path, filename));
            await outFile.writeAsBytes(file.content as List<int>);
          }
        }

        return BackupResult(
          success: true, 
          message: 'backupMerged',
          mergeDetails: mergeResult.details,
        );
      }
    } catch (e) {
      return BackupResult(success: false, message: 'backupImportError|$e');
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
