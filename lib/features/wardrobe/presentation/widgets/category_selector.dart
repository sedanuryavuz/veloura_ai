import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/enums/categories.dart';

class CategorySelector extends StatelessWidget {
  final ClothingCategory value;
  final ValueChanged<ClothingCategory> onChanged;

  const CategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _getCategoryDescription(ClothingCategory category) {
    switch (category) {
      case ClothingCategory.top:
        return "Upper body";
      case ClothingCategory.bottom:
        return "Lower body";
      case ClothingCategory.shoes:
        return "Footwear";
      case ClothingCategory.accessories:
        return "Accessories";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Category",
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: ClothingCategory.values
                .where((e) => e != ClothingCategory.all)
                .map((category) {
              final isSelected = value == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(category.displayName),
                      Text(
                        _getCategoryDescription(category),
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onChanged(category);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.primaryLight.withOpacity(0.2),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
