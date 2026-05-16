import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../outfit/data/models/outfit_model.dart';


class PlannedOutfitCard extends StatelessWidget {
  final OutfitModel outfit;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PlannedOutfitCard({
    super.key,
    required this.outfit,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),
        ),

        child: Row(
          children: [
            if (outfit.top != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),

                child: CachedNetworkImage(
                  imageUrl: outfit.top!.imageUrl,
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Saved Outfit",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${outfit.createdAt.day}.${outfit.createdAt.month}.${outfit.createdAt.year}",
                  ),
                ],
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onDelete != null)
                  IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),

                if (onTap != null)
                  const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
