import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/ai_outfit_response.dart';
import '../../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../../../wardrobe/domain/entities/clothing_item.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4, left: 12, right: 12),
            padding: const EdgeInsets.all(14),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            decoration: BoxDecoration(
              gradient: isUser
                  ? const LinearGradient(
                      colors: [
                        AppColors.primary,
                        Color(0xffF2C6C8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xffF4F4F6),
                      ],
                    ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(0),
                bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Colors.white : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          if (!isUser && message.outfitResponse != null && message.outfitResponse!.outfitItems.isNotEmpty)
            _buildOutfitRecommendationCard(context, message.outfitResponse!),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOutfitRecommendationCard(BuildContext context, AiOutfitResponse outfit) {
    final wardrobeItems = context.watch<WardrobeProvider>().items;

    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 4),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                topRight: Radius.circular(19),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primaryDark, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    outfit.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (outfit.style.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      outfit.style.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Items grid/list
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: outfit.outfitItems.map((item) {
                // Find matching item in wardrobe
                ClothingItem? matchedItem;
                try {
                  matchedItem = wardrobeItems.firstWhere((w) => w.id == item.id);
                } catch (_) {
                  matchedItem = null;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: matchedItem != null
                            ? Image.network(
                                matchedItem.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildCategoryFallback(item.category),
                              )
                            : _buildCategoryFallback(item.category),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Weather note if present
          if (outfit.weatherNote != null && outfit.weatherNote!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, color: AppColors.primaryDark, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        outfit.weatherNote!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryFallback(String category) {
    IconData icon;
    switch (category.toLowerCase()) {
      case 'top':
        icon = Icons.checkroom;
        break;
      case 'bottom':
        icon = Icons.layers;
        break;
      case 'shoes':
        icon = Icons.nordic_walking;
        break;
      default:
        icon = Icons.style;
    }
    return Icon(icon, color: AppColors.primaryDark.withOpacity(0.5));
  }
}
