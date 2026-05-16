import 'package:flutter/material.dart';
import '../../domain/entities/outfit.dart';
import 'outfit_card.dart';
import '../../utils/outfit_theme.dart';

class OutfitGrid extends StatelessWidget {
  final List<Outfit> outfits;

  const OutfitGrid({super.key, required this.outfits});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: OutfitTheme.spacingM,
        vertical: OutfitTheme.spacingS,
      ),
      itemCount: outfits.length,
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        return OutfitCard(
          key: ValueKey(outfit.id),
          outfit: outfit,
        );
      },
    );
  }
}
