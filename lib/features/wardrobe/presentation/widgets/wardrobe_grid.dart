import 'package:flutter/material.dart';
import '../../../../core/widgets/v_delete_dialog.dart';
import '../provider/wardrobe_provider.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // Fixed: Bottom padding (120px) to clear bottom nav
      itemCount: provider.filteredItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];

        return ClothingCard(
          item: item,
          onDelete: () {
            VDeleteDialog.show(
              context,
              title: "Delete Item?",
              content: "Do you want to permanently remove this item from your wardrobe?",
              onDelete: () => provider.deleteItem(item),
            );
          },
        );
      },
    );
  }
}
