import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;

  const CategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['all', 'top', 'bottom', 'shoes', 'accessories'];

    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemBuilder: (context, index) {
          final category = categories[index];

          final isSelected = selected == category;

          return GestureDetector(
            onTap: () {
              onSelected(category);
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

              decoration: BoxDecoration(
                color: isSelected ? const Color(0xffE8B4B8) : Colors.white,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },

        separatorBuilder: (_, __) => const SizedBox(width: 10),

        itemCount: categories.length,
      ),
    );
  }
}
