enum ClothingCategory {
  all,
  top,
  bottom,
  shoes,
  accessories,
}

extension ClothingCategoryExt on ClothingCategory {
  String get displayName {
    if (this == ClothingCategory.all) return 'All';
    return name[0].toUpperCase() + name.substring(1); 
  }

  static ClothingCategory fromString(String category) {
    return ClothingCategory.values.firstWhere(
      (e) => e.name == category.toLowerCase(),
      orElse: () => ClothingCategory.top, 
    );
  }
}
extension ClothingCategorySelector on ClothingCategory {
  void applySelection(
    dynamic item,
    dynamic outfitProvider,
  ) {
    switch (this) {
      case ClothingCategory.top:
        outfitProvider.selectTop(item);
        break;

      case ClothingCategory.bottom:
        outfitProvider.selectBottom(item);
        break;

      case ClothingCategory.shoes:
        outfitProvider.selectShoes(item);
        break;

      default:
        break;
    }
  }
}
extension ClothingCategoryPrompt on ClothingCategory {
  static String get aiCategories {
    return ClothingCategory.values
        .where((e) => e != ClothingCategory.all)
        .map((e) => e.name)
        .join(', ');
  }
  
}