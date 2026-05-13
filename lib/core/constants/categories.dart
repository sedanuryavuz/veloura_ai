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