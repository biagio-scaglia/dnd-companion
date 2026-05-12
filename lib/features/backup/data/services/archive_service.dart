import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

class ArchiveService {
  /// Crea un archivio ZIP (.dndc) da una directory.
  Future<void> createArchive(Directory sourceDir, File outputFile) async {
    final archive = Archive();

    await for (final entity in sourceDir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: sourceDir.path);
        final bytes = await entity.readAsBytes();
        archive.addFile(ArchiveFile(relativePath, bytes.length, bytes));
      }
    }

    final encoder = ZipEncoder();
    final zipBytes = encoder.encode(archive);
    if (zipBytes != null) {
      await outputFile.writeAsBytes(zipBytes);
    } else {
      throw Exception('Failed to encode ZIP archive');
    }
  }

  /// Estrae un archivio ZIP in una directory target.
  /// Include la validazione dei path per evitare Zip Slip.
  Future<void> extractArchive(File zipFile, Directory targetDir) async {
    final bytes = await zipFile.readAsBytes();
    final decoder = ZipDecoder();
    final archive = decoder.decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      
      // Validazione Path (Zip Slip Protection)
      final targetFilePath = p.join(targetDir.path, filename);
      if (!p.isWithin(targetDir.path, targetFilePath)) {
        throw Exception('Vulnerabilità Zip Slip rilevata nel file: $filename');
      }

      if (file.isFile) {
        final data = file.content as List<int>;
        final outFile = File(targetFilePath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(data);
      } else {
        await Directory(targetFilePath).create(recursive: true);
      }
    }
  }
}
