import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../wardrobe/models/clothing_item_model.dart';
import '../utils/outfit_theme.dart';

class OutfitSelectorGrid extends StatelessWidget {
  final List<ClothingItemModel> items;
  final Function(ClothingItemModel) onTap;
  final ClothingItemModel? selectedItem;

  const OutfitSelectorGrid({
    super.key,
    required this.items,
    required this.onTap,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "No items found",
          style: OutfitTheme.subtitleStyle,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: OutfitTheme.spacingM,
        vertical: OutfitTheme.spacingM,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: OutfitTheme.spacingM,
        mainAxisSpacing: OutfitTheme.spacingM,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItem?.id == item.id;

        return GestureDetector(
          onTap: () => onTap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: OutfitTheme.borderRadiusM,
              border: Border.all(
                color: isSelected ? OutfitTheme.accentColor : OutfitTheme.borderSubtle,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? OutfitTheme.softShadow : null,
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: isSelected
                ? const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: OutfitTheme.accentColor,
                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}