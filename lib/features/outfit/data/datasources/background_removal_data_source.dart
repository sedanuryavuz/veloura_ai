import 'dart:io';
import 'package:native_cutout/native_cutout.dart';
import 'package:path_provider/path_provider.dart';

abstract class BackgroundRemovalDataSource {
  Future<File?> removeBackground(File image);
}

class BackgroundRemovalDataSourceImpl implements BackgroundRemovalDataSource {
  @override
  Future<File?> removeBackground(File image) async {
    try {
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
          writeToCache: true,
        ),
      );

      switch (result) {
        case CutoutFileSuccess(:final path):
          return File(path);

        case CutoutBytesSuccess(:final pngBytes):
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/cutout_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(pngBytes);
          return file;

        case CutoutFailure(:final code, :final message):
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}
