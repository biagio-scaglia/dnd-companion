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
      );

      if (result == null || result.files.single.path == null) {
        _setLoading(false);
        return;
      }

      final file = File(result.files.single.path!);
      
      if (!file.path.endsWith('.comp')) {
        _lastResult = BackupResult(success: false, message: 'invalidBackupFile');
        _setLoading(false);
        return;
      }

      final preview = await backupService.generatePreview(file);
      if (preview != null) {
        _preview = preview;
        _selectedFile = file;
      } else {
        _lastResult = BackupResult(success: false, message: 'cannotReadManifest');
      }
    } catch (e) {
      _lastResult = BackupResult(success: false, message: 'backupReadError|$e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> executeImport({bool overwrite = false}) async {
    if (_selectedFile == null) return;
    _setLoading(true);
    
    try {
      final result = await backupService.importBackup(_selectedFile!, overwrite: overwrite);
      _lastResult = result;
      _preview = null;
      _selectedFile = null;
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
