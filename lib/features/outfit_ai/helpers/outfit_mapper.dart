import '../../../core/constants/enums/categories.dart';

class OutfitMapper {
  static void applyAiResult({
    required List aiItems,
    required List wardrobe,
    required dynamic outfitProvider,
  }) {
    outfitProvider.clearSelection();

    for (final item in aiItems) {
      final wardrobeItem = wardrobe.firstWhere(
        (e) => e.id == item.id,
      );

      final category =
          ClothingCategoryExt.fromString(item.category);

      category.applySelection(
        wardrobeItem,
        outfitProvider,
      );
    }
  }
}