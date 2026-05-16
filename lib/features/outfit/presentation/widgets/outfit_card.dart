import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../provider/outfit_provider.dart';
import '../../domain/entities/outfit.dart';
import '../pages/create_outfit_page.dart';
import '../../utils/outfit_theme.dart';

class OutfitCard extends StatelessWidget {
  final Outfit outfit;

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
                _buildImage(outfit.top?.imageUrl),
                _buildImage(outfit.bottom?.imageUrl),
                _buildImage(outfit.shoes?.imageUrl),
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
                context.read<OutfitProvider>().setEditingOutfit(outfit);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateOutfitPage()),
                );
              } else if (value == 'delete') {
                context.read<OutfitProvider>().deleteOutfit(outfit.id);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null) {
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
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
