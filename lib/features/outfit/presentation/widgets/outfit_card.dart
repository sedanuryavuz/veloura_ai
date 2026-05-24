import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../provider/outfit_provider.dart';
import '../../domain/entities/outfit.dart';
import '../pages/create_outfit_page.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/v_card.dart';
import '../../../../core/widgets/v_delete_dialog.dart';

class OutfitCard extends StatelessWidget {
  final Outfit outfit;

  const OutfitCard({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return VCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  outfit.name.isEmpty ? "Unnamed Outfit" : outfit.name,
                  style: AppTextStyles.h3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textLight),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    context.read<OutfitProvider>().setEditingOutfit(outfit);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateOutfitPage()),
                    );
                  } else if (value == 'delete') {
                    VDeleteDialog.show(
                      context,
                      title: "Delete Outfit?",
                      content: "Are you sure you want to delete this outfit? This cannot be undone.",
                      onDelete: () => context.read<OutfitProvider>().deleteOutfit(outfit.id),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImage(outfit.top?.imageUrl, "Top"),
              const SizedBox(width: 8),
              _buildImage(outfit.bottom?.imageUrl, "Bottom"),
              const SizedBox(width: 8),
              _buildImage(outfit.shoes?.imageUrl, "Shoes"),
              const SizedBox(width: 8),
              _buildImage(outfit.accessory?.imageUrl, "Acc"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.checkroom_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Complete Set',
                style: AppTextStyles.bodySmall,
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? url, String label) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
          ),
          child: url != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_rounded, color: AppColors.textLight),
                  ),
                )
              : Center(
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textLight),
                  ),
                ),
        ),
      ),
    );
  }
}
