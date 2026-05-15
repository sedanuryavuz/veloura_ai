import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePickerField({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: image == null
            ? const Icon(Icons.add_a_photo, size: 50)
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(image!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}