import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/outfit.dart';

class OutfitLibrarySelectionPage extends StatelessWidget {
  final List<Outfit> outfits;
  final Outfit? selectedOutfit;

  const OutfitLibrarySelectionPage({
    super.key,
    required this.outfits,
    this.selectedOutfit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Outfit Library"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: outfits.isEmpty
            ? Center(
                child: Text(
                  "No outfits saved yet.",
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.88,
                ),
                itemCount: outfits.length,
                itemBuilder: (context, index) {
                  final outfit = outfits[index];
                  final isSelected = selectedOutfit?.id == outfit.id;

                  return GestureDetector(
                    onTap: () => Navigator.pop(context, outfit),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.black.withOpacity(0.05),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isSelected ? 0.08 : 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  outfit.name.isEmpty ? "Unnamed" : outfit.name,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildMiniImage(outfit.top?.imageUrl),
                                _buildMiniImage(outfit.bottom?.imageUrl),
                                _buildMiniImage(outfit.shoes?.imageUrl),
                                _buildMiniImage(outfit.accessory?.imageUrl),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildMiniImage(String? url) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
      ),
      child: url != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported_rounded,
                  size: 12,
                  color: AppColors.textLight,
                ),
              ),
            )
          : const Icon(
              Icons.checkroom_rounded,
              size: 12,
              color: AppColors.textLight,
            ),
    );
  }
}
