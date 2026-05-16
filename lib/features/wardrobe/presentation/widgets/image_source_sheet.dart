import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(ImageSource source) onSourceSelected;
  final File? currentImage;
  final String? networkImageUrl;

  const ImageSourceSheet({
    super.key,
    required this.onSourceSelected,
    this.currentImage,
    this.networkImageUrl,
  });

  static void show({
    required BuildContext context,
    required Function(ImageSource source) onSourceSelected,
    File? currentImage,
    String? networkImageUrl,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ImageSourceSheet(
        onSourceSelected: onSourceSelected,
        currentImage: currentImage,
        networkImageUrl: networkImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.camera);
              },
            ),
            if (currentImage != null || networkImageUrl != null)
              ListTile(
                leading: const Icon(Icons.visibility_rounded),
                title: const Text('View Image'),
                onTap: () {
                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        insetPadding: const EdgeInsets.all(12),
                        child: InteractiveViewer(
                          child: currentImage != null
                              ? Image.file(currentImage!)
                              : Image.network(networkImageUrl!),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
