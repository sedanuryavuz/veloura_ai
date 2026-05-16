import 'package:flutter/material.dart';
import '../../../outfit/domain/entities/outfit.dart';
import '../../../../core/widgets/v_card.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_colors.dart';

class EventCard extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.outfit,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Hero(
            tag: 'outfit_${outfit.id}',
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: outfit.items.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        outfit.items.first.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Icon(Icons.image_not_supported, color: AppColors.textLight),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  outfit.name,
                  style: AppTextStyles.h3.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.checkroom_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${outfit.items.length} pieces',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22),
                onPressed: onDelete,
              ),
            ),
          if (onTap != null)
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
        ],
      ),
    );
  }
}
