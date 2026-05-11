import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
    ),
  );
}