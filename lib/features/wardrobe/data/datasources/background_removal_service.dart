import 'dart:io';
import 'package:native_cutout/native_cutout.dart';
import 'package:path_provider/path_provider.dart';

class BackgroundRemovalService {
  Future<File?> removeBackground(File image) async {
    try {
      // Android'de model kontrolü
      if (!(await NativeCutout.isModelAvailable())) {
        final downloaded = await NativeCutout.downloadModel();
        if (!downloaded) {
          throw Exception("ML Kit model indirilemedi");
        }
      }

      final result = await NativeCutout.removeBackground(
        image.path,
        options: const CutoutOptions(
          cropToSubject: true,
          writeToCache: true, // cache'e yazar, path döner
        ),
      );

      switch (result) {
        case CutoutFileSuccess(:final path):
          return File(path);

        case CutoutBytesSuccess(:final pngBytes):
          // writeToCache: false kullanırsan buraya düşer
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/cutout_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(pngBytes);
          return file;

        case CutoutFailure(:final code, :final message):
          print("BG REMOVE FAILED: ${code.name} - $message");
          return null;
      }
    } catch (e) {
      print("BG REMOVE ERROR: $e");
      return null;
    }
  }
}