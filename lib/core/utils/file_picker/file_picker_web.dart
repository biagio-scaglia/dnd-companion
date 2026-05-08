import 'dart:html' as html;
import 'dart:async';

Future<Map<String, String>?> pickFile() async {
  final completer = Completer<Map<String, String>?>();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '.json'; // Accetta solo file JSON
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.readAsText(file);
      reader.onLoadEnd.listen((e) {
        completer.complete({
          'name': file.name,
          'content': reader.result as String,
        });
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}
