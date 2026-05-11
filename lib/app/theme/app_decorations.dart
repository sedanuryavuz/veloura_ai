import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  static BoxDecoration glass = BoxDecoration(
    color: AppColors.glass,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withOpacity(0.3),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 20,
        offset: const Offset(0, 10),
      )
    ],
  );
}