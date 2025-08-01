import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FilesSystem {
  static Future<String> writeFile({
    required Uint8List bytes,
    required String extension,
    required String pathBefore
  }) async {
    
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/file_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final file = File(path);
    await file.writeAsBytes(bytes);
    if (pathBefore.isNotEmpty) {
      final oldFile = File(pathBefore);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }
    return file.path;
  }
}