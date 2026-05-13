import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../data/services/backup_service.dart';
import '../domain/models/import_preview.dart';
import '../domain/models/backup_result.dart';

class BackupController extends ChangeNotifier {
  final BackupService backupService;

  BackupController({required this.backupService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ImportPreview? _preview;
  ImportPreview? get preview => _preview;

  BackupResult? _lastResult;
  BackupResult? get lastResult => _lastResult;

  File? _selectedFile;
  File? get selectedFile => _selectedFile;

  Uint8List? _selectedBytes;
  Uint8List? get selectedBytes => _selectedBytes;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> exportBackup() async {
    _setLoading(true);
    _lastResult = null;

    try {
      final bytes = await backupService.exportBackupBytes();

      if (kIsWeb) {
        await FilePicker.saveFile(
          dialogTitle: 'Salva Backup',
          fileName: 'Dnd_Backup_${DateTime.now().millisecondsSinceEpoch}.comp',
          bytes: Uint8List.fromList(bytes),
        );
        _lastResult = BackupResult(success: true, message: 'backupDownloadSuccess');
      } else {
        String? outputFile = await FilePicker.saveFile(
          dialogTitle: 'Salva Backup',
          fileName: 'Dnd_Backup_${DateTime.now().millisecondsSinceEpoch}.comp',
          type: FileType.any,
          bytes: Uint8List.fromList(bytes),
        );

        if (outputFile == null) {
          _setLoading(false);
          return;
        }

        if (!outputFile.endsWith('.comp')) {
          outputFile += '.comp';
        }

        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          // Su Android e iOS, FilePicker.saveFile salva già il file se passiamo i bytes.
          // Inoltre il path restituito potrebbe essere un URI non gestibile direttamente da File().
        } else {
          final file = File(outputFile);
          await file.writeAsBytes(bytes);
        }
        _lastResult = BackupResult(success: true, message: 'backupCreateSuccess');
      }
    } catch (e) {
      _lastResult = BackupResult(success: false, message: 'backupExportError|$e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickAndPreviewBackup() async {
    _setLoading(true);
    _preview = null;
    _lastResult = null;
    _selectedFile = null;

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        withData: kIsWeb, // Importante per il Web!
      );

      if (result == null) {
        _setLoading(false);
        return;
      }

      final fileName = result.files.single.name;
      
      // Rimosso il controllo rigido sull'estensione .comp perché su Android può dare problemi.
      // Ci fideremo del contenuto del file (ZipDecoder fallirà se non è valido).

      if (kIsWeb) {
        final bytes = result.files.single.bytes;
        if (bytes == null) {
          _lastResult = BackupResult(success: false, message: 'cannotReadManifest');
          _setLoading(false);
          return;
        }

        final preview = await backupService.generatePreviewFromBytes(bytes);
        if (preview != null) {
          _preview = preview;
          _selectedBytes = bytes;
        } else {
          _lastResult = BackupResult(success: false, message: 'cannotReadManifest');
        }
      } else {
        if (result.files.single.path == null) {
          _setLoading(false);
          return;
        }
        final file = File(result.files.single.path!);
        try {
          final bytes = await file.readAsBytes();
          final preview = await backupService.generatePreviewFromBytes(bytes);
          if (preview != null) {
            _preview = preview;
            _selectedBytes = bytes;
            _selectedFile = file;
          } else {
            _lastResult = BackupResult(success: false, message: 'cannotReadManifest');
          }
        } catch (e) {
          _lastResult = BackupResult(success: false, message: 'backupReadError|$e');
        }
      }
    } catch (e) {
      _lastResult = BackupResult(success: false, message: 'backupReadError|$e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> executeImport({bool overwrite = false}) async {
    if (_selectedFile == null && _selectedBytes == null) return;
    _setLoading(true);
    
    try {
      final BackupResult result;
      if (_selectedBytes != null) {
        result = await backupService.importBackupFromBytes(_selectedBytes!, overwrite: overwrite);
      } else if (_selectedFile != null) {
        result = await backupService.importBackup(_selectedFile!, overwrite: overwrite);
      } else {
        _setLoading(false);
        return;
      }
      _lastResult = result;
      _preview = null;
      _selectedFile = null;
      _selectedBytes = null;
    } catch (e) {
      _lastResult = BackupResult(success: false, message: 'backupImportError|$e');
    } finally {
      _setLoading(false);
    }
  }

  void clearLastResult() {
    _lastResult = null;
    notifyListeners();
  }
}
