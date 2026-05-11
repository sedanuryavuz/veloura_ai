import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    letterSpacing: 0.3,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.darkText,
  );

  static const small = TextStyle(
    fontSize: 13,
    color: Colors.black54,
  );
}