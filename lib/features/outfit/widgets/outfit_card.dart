import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/outfit_controller.dart';
import '../models/outfit_model.dart';
import '../pages/outfit_builder_page.dart';
import '../utils/outfit_theme.dart';

class OutfitCard extends StatelessWidget {
  final OutfitModel outfit;

  const OutfitCard({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: OutfitTheme.spacingM),
      padding: const EdgeInsets.all(OutfitTheme.spacingM),
      decoration: BoxDecoration(
        color: OutfitTheme.cardBackground,
        borderRadius: OutfitTheme.borderRadiusL,
        boxShadow: OutfitTheme.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImage(outfit.top?.imagePath),
                _buildImage(outfit.bottom?.imagePath),
                _buildImage(outfit.shoes?.imagePath),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: OutfitTheme.textSecondary),
            shape: RoundedRectangleBorder(borderRadius: OutfitTheme.borderRadiusM),
            elevation: 4,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20, color: OutfitTheme.textPrimary),
                    SizedBox(width: 12),
                    Text('Edit Outfit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                context.read<OutfitController>().setEditingOutfit(outfit);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OutfitBuilderPage()),
                );
              } else if (value == 'delete') {
                context.read<OutfitController>().deleteOutfit(outfit.id);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null) {
      return Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
          color: OutfitTheme.background,
          borderRadius: OutfitTheme.borderRadiusM,
          border: Border.all(color: OutfitTheme.borderSubtle, width: 1),
        ),
      );
    }

    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: OutfitTheme.borderRadiusM,
        border: Border.all(color: OutfitTheme.borderSubtle, width: 0.5),
        image: DecorationImage(
          image: FileImage(File(path)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
