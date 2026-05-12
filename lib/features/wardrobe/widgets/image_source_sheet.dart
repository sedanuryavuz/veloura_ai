import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_service.dart';

class ImageSourceSheet {
  static final ImageService _imageService =
      ImageService();

  static Future<void> show({
    required BuildContext context,
    required Function(File image) onImagePicked,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);

                  final image =
                      await _imageService.pickImage(
                    ImageSource.gallery,
                  );

                  if (image != null) {
                    onImagePicked(image);
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);

                  final image =
                      await _imageService.pickImage(
                    ImageSource.camera,
                  );

                  if (image != null) {
                    onImagePicked(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}