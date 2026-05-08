import 'dart:html' as html;
import 'dart:async';

Future<Map<String, String>?> pickFile() async {
  final completer = Completer<Map<String, String>?>();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '*/*'; // Accetta tutti i file
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      // Su web non possiamo avere il path reale, usiamo il nome come path simulato
      completer.complete({
        'name': file.name,
        'path': file.name, 
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}
