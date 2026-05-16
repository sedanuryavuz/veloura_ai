import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  // Border Radius
  static const double cardRadius = 20.0;
  static const double buttonRadius = 16.0;
  static const double inputRadius = 12.0;

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.1),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // Cards
  static BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(cardRadius),
    boxShadow: softShadow,
  );

  static BoxDecoration glassCard = BoxDecoration(
    color: AppColors.glass,
    borderRadius: BorderRadius.circular(cardRadius),
    border: Border.all(color: Colors.white.withOpacity(0.5)),
    boxShadow: softShadow,
  );

  // Inputs
  static InputDecoration inputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) =>
      InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textLight),
      );
}