import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  /// Permette di selezionare un file generico o con estensioni specifiche.
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print('Errore durante la selezione del file: $e');
    }
    return null;
  }

  /// Permette di selezionare un'immagine.
  Future<File?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print('Errore durante la selezione dell\'immagine: $e');
    }
    return null;
  }
}
