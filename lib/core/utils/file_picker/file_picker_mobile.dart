import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<Map<String, String>?> pickFile() async {
  FilePickerResult? result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result != null && result.files.single.path != null) {
    File file = File(result.files.single.path!);
    String content = await file.readAsString();
    return {
      'name': result.files.single.name,
      'content': content,
    };
  }
  return null;
}
