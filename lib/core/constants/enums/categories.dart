import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

enum ClothingCategory {
  all,
  top,
  bottom,
  shoes,
  dress,
  outerwear,
  bag,
  hat,
  socks,
  jewelry,
  watch,
  glasses,
  belt,
  accessory,
  accessories, // Keep for backward compatibility
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
      case ClothingCategory.dress:
        return l10n.categoryDress;
      case ClothingCategory.outerwear:
        return l10n.categoryOuterwear;
      case ClothingCategory.bag:
        return l10n.categoryBag;
      case ClothingCategory.hat:
        return l10n.categoryHat;
      case ClothingCategory.socks:
        return l10n.categorySocks;
      case ClothingCategory.jewelry:
        return l10n.categoryJewelry;
      case ClothingCategory.watch:
        return l10n.categoryWatch;
      case ClothingCategory.glasses:
        return l10n.categoryGlasses;
      case ClothingCategory.belt:
        return l10n.categoryBelt;
      case ClothingCategory.accessory:
        return l10n.categoryAccessory;
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
      case ClothingCategory.dress:
        return l10n.categoryDressDesc;
      case ClothingCategory.outerwear:
        return l10n.categoryOuterwearDesc;
      case ClothingCategory.bag:
        return l10n.categoryBagDesc;
      case ClothingCategory.hat:
        return l10n.categoryHatDesc;
      case ClothingCategory.socks:
        return l10n.categorySocksDesc;
      case ClothingCategory.jewelry:
        return l10n.categoryJewelryDesc;
      case ClothingCategory.watch:
        return l10n.categoryWatchDesc;
      case ClothingCategory.glasses:
        return l10n.categoryGlassesDesc;
      case ClothingCategory.belt:
        return l10n.categoryBeltDesc;
      case ClothingCategory.accessory:
        return l10n.categoryAccessoryDesc;
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

      case ClothingCategory.dress:
        outfitProvider.selectDress(item);
        break;

      case ClothingCategory.outerwear:
        outfitProvider.selectOuterwear(item);
        break;

      case ClothingCategory.accessories:
      case ClothingCategory.bag:
      case ClothingCategory.hat:
      case ClothingCategory.socks:
      case ClothingCategory.jewelry:
      case ClothingCategory.watch:
      case ClothingCategory.glasses:
      case ClothingCategory.belt:
      case ClothingCategory.accessory:
        outfitProvider.toggleAccessory(item);
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