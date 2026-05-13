import 'package:flutter/material.dart';

import '../providers/wardrobe_provider.dart';
import 'clothing_card.dart';
import 'empty_wardrobe.dart';

class WardrobeGrid extends StatelessWidget {
  final WardrobeProvider provider;

  const WardrobeGrid({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.filteredItems.isEmpty) {
      return const EmptyWardrobe();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: provider.filteredItems.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),

      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];

        return ClothingCard(
          item: item,

          onDelete: () {
            provider.deleteItem(item);
          },
        );
      },
    );
  }
}
