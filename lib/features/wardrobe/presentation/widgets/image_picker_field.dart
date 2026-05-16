import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final Widget imageWidget;
  final VoidCallback onTap;

  const ImagePickerField({
    super.key,
    required this.imageWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: imageWidget,
      ),
    );
  }
}
