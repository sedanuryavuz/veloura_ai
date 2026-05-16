import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class EmptyWardrobe extends StatelessWidget {
  const EmptyWardrobe({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60), // Fixed: Offsetting for bottom navigation bar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.checkroom_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Your wardrobe is empty ✨',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding your favorite pieces\nand create aesthetic outfits.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
