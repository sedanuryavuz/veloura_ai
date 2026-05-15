import 'package:flutter/material.dart';

import '../../../core/constants/enums/categories.dart';

class CategoryDropdown extends StatelessWidget {
  final ClothingCategory value;
  final ValueChanged<ClothingCategory> onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ClothingCategory>(
      value: value,
      isExpanded: true,
      items: ClothingCategory.values
          .where((e) => e != ClothingCategory.all)
          .map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.displayName),
        );
      }).toList(),
      onChanged: (v) => onChanged(v!),
    );
  }
}