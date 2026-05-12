import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(
    ImageSource source,
  ) async {

    final image = await _picker.pickImage(
      source: source,
    );

    if (image == null) return null;

    final appDir =
        await getApplicationDocumentsDirectory();

    final fileName =
        DateTime.now()
            .millisecondsSinceEpoch
            .toString();

    final savedImage =
        await File(image.path).copy(
      '${appDir.path}/$fileName.jpg',
    );

    return savedImage;
  }
}