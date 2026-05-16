import 'package:flutter/material.dart';
import '../../domain/entities/outfit.dart';
import 'outfit_card.dart';

class OutfitGrid extends StatelessWidget {
  final List<Outfit> outfits;

  const OutfitGrid({super.key, required this.outfits});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // Fixed: Bottom padding (120px) to clear bottom nav
      itemCount: outfits.length,
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OutfitCard(
            key: ValueKey(outfit.id),
            outfit: outfit,
          ),
        );
      },
    );
  }
}
