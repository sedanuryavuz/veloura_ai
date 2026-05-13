import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/outfit_controller.dart';
import '../utils/outfit_theme.dart';

class OutfitPreview extends StatelessWidget {
  final OutfitController outfit;

  const OutfitPreview({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: OutfitTheme.spacingL,
        vertical: OutfitTheme.spacingM,
      ),
      padding: const EdgeInsets.symmetric(vertical: OutfitTheme.spacingM),
      decoration: BoxDecoration(
        color: OutfitTheme.cardBackground,
        borderRadius: OutfitTheme.borderRadiusL,
        boxShadow: OutfitTheme.softShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItem(outfit.selectedTop, "Select Top"),
          _buildItem(outfit.selectedBottom, "Select Bottom"),
          _buildItem(outfit.selectedShoes, "Select Shoes", height: 60),
        ],
      ),
    );
  }

  Widget _buildItem(dynamic item, String placeholder, {double height = 90}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: item == null
          ? Container(
              key: ValueKey('placeholder_$placeholder'),
              height: height,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: OutfitTheme.borderRadiusM,
                border: Border.all(
                  color: OutfitTheme.borderSubtle,
                  style: BorderStyle.solid,
                ),
                color: OutfitTheme.background,
              ),
              child: Center(
                child: Text(
                  placeholder,
                  style: OutfitTheme.labelStyle,
                ),
              ),
            )
          : Container(
              key: ValueKey(item.id),
              height: height,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: OutfitTheme.borderRadiusM,
                image: DecorationImage(
                  image: FileImage(File(item.imagePath)),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
            ),
    );
  }
}
