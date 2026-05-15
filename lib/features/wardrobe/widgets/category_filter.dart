import 'package:flutter/material.dart';

import '../../../core/constants/enums/categories.dart';

class CategoryFilter extends StatelessWidget {
  final ClothingCategory selected;
  final Function(ClothingCategory) onSelected;

  const CategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ClothingCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = ClothingCategory.values[index];
          final isSelected = selected == category;

          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xffE8B4B8) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}