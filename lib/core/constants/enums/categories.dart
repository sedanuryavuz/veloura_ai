import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

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

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ClothingCategory.all:
        return l10n.categoryAll;
      case ClothingCategory.top:
        return l10n.categoryTop;
      case ClothingCategory.bottom:
        return l10n.categoryBottom;
      case ClothingCategory.shoes:
        return l10n.categoryShoes;
      case ClothingCategory.accessories:
        return l10n.categoryAccessories;
    }
  }

  String localizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ClothingCategory.all:
        return '';
      case ClothingCategory.top:
        return l10n.categoryTopDesc;
      case ClothingCategory.bottom:
        return l10n.categoryBottomDesc;
      case ClothingCategory.shoes:
        return l10n.categoryShoesDesc;
      case ClothingCategory.accessories:
        return l10n.categoryAccessoriesDesc;
    }
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

      case ClothingCategory.accessories:
        outfitProvider.selectAccessory(item);
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