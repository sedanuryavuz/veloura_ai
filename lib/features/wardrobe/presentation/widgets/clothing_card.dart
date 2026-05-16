import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../core/widgets/v_card.dart';
import '../../../../core/constants/enums/categories.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/enums/clothing_form_mode.dart';
import '../pages/clothing_form_page.dart';

class ClothingCard extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onDelete;

  const ClothingCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClothingFormPage(
              mode: ClothingFormMode.edit,
              item: item,
            ),
          ),
        );
      },
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDecorations.cardRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        child: const Icon(Icons.image_not_supported_rounded, color: AppColors.textLight),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: AppDecorations.softShadow,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.category.displayName,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
