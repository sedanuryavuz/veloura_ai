import 'package:flutter/material.dart';

import '../controllers/wardrobe_controller.dart';
import 'clothing_card.dart';
import 'empty_wardrobe.dart';

class WardrobeGrid extends StatelessWidget {
  final WardrobeController controller;

  const WardrobeGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.filteredItems.isEmpty) {
      return const EmptyWardrobe();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: controller.filteredItems.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),

      itemBuilder: (context, index) {
        final item = controller.filteredItems[index];

        return ClothingCard(
          item: item,

          onDelete: () {
            controller.deleteItem(item.id);
          },
        );
      },
    );
  }
}
