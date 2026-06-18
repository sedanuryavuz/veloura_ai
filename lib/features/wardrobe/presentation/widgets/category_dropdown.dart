import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

import '../../../../core/constants/enums/categories.dart';

class CategoryDropdown extends StatelessWidget {
  final ClothingCategory value;
  final ValueChanged<ClothingCategory> onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _getCategoryDescription(ClothingCategory category) {
    switch (category) {
      case ClothingCategory.top:
        return "Upper body clothing items";
      case ClothingCategory.bottom:
        return "Lower body clothing items";
      case ClothingCategory.shoes:
        return "Footwear and shoes";
      case ClothingCategory.dress:
        return "One-piece dresses and jumpsuits";
      case ClothingCategory.outerwear:
        return "Coats, jackets, and cardigans";
      case ClothingCategory.bag:
        return "Bags and purses";
      case ClothingCategory.hat:
        return "Hats, caps, and beanies";
      case ClothingCategory.socks:
        return "Socks and hosiery";
      case ClothingCategory.jewelry:
        return "Necklaces, rings, and earrings";
      case ClothingCategory.watch:
        return "Watches and smartwatches";
      case ClothingCategory.glasses:
        return "Sunglasses and spectacles";
      case ClothingCategory.belt:
        return "Belts and straps";
      case ClothingCategory.accessory:
        return "Other fashion accessories";
      default:
        return "Select a category";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ClothingCategory>(
      value: value == ClothingCategory.all || value == ClothingCategory.accessories ? ClothingCategory.top : value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: "Category",
      ),
      items: ClothingCategory.values
          .where((e) => e != ClothingCategory.all && e != ClothingCategory.accessories)
          .map((category) {
        return DropdownMenuItem(
          value: category,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category.displayName,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _getCategoryDescription(category),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      // Adjusting height for descriptions
      itemHeight: 60,
    );
  }
}