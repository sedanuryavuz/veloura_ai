import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../outfit/presentation/provider/outfit_provider.dart';
import '../../../outfit/domain/entities/outfit.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/supabase_service.dart';

enum OutfitFilterType {
  all,
  favorites,
  mostWorn,
  leastWorn,
  seasonal,
  casual,
  formal
}

extension OutfitFilterTypeExt on OutfitFilterType {
  String get displayName {
    switch (this) {
      case OutfitFilterType.all: return "All";
      case OutfitFilterType.favorites: return "Favorites";
      case OutfitFilterType.mostWorn: return "Most Worn";
      case OutfitFilterType.leastWorn: return "Least Worn";
      case OutfitFilterType.seasonal: return "Seasonal";
      case OutfitFilterType.casual: return "Casual";
      case OutfitFilterType.formal: return "Formal";
    }
  }
}

class OutfitSelectionSheet extends StatefulWidget {
  final Outfit? selectedOutfit;
  final Function(Outfit) onSelect;

  const OutfitSelectionSheet({
    super.key,
    this.selectedOutfit,
    required this.onSelect,
  });

  static void show({
    required BuildContext context,
    required Function(Outfit) onSelect,
    Outfit? selectedOutfit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OutfitSelectionSheet(
          selectedOutfit: selectedOutfit,
          onSelect: onSelect,
        );
      },
    );
  }

  @override
  State<OutfitSelectionSheet> createState() => _OutfitSelectionSheetState();
}

class _OutfitSelectionSheetState extends State<OutfitSelectionSheet> {
  OutfitFilterType _activeFilter = OutfitFilterType.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<OutfitProvider>().loadOutfits(userId);
      }
      context.read<OutfitProvider>().fetchWeather();
    });
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OutfitProvider>();
    final outfits = provider.outfits;

    // Filter outfits (future filtering architecture ready)
    List<Outfit> filteredOutfits = outfits;
    if (_activeFilter == OutfitFilterType.favorites) {
      // Placeholder filter
    }

    // Section 1: Recently Generated (AI generated, sorted by date)
    final recentlyGenerated = outfits
        .where((o) => provider.isAiGenerated(o))
        .toList();
    recentlyGenerated.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Section 2: Weather suitability
    final currentWeather = provider.currentWeather;
    List<Outfit> weatherRecommended = [];
    if (currentWeather != null) {
      final scored = outfits.map((o) {
        final score = provider.calculateWeatherSuitability(o, currentWeather);
        return MapEntry(o, score);
      }).where((entry) => entry.value > 0).toList();
      
      scored.sort((a, b) => b.value.compareTo(a.value));
      weatherRecommended = scored.map((entry) => entry.key).toList();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xffFDF6F6),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SELECT OUTFIT",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primaryDark,
                    letterSpacing: 2,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1a000000)),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION 1: Recently Generated ---
                  _buildSectionHeader("RECENTLY GENERATED"),
                  if (recentlyGenerated.isEmpty)
                    _buildEmptyState("No recently generated outfits.")
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: recentlyGenerated.length,
                        itemBuilder: (context, index) {
                          final outfit = recentlyGenerated[index];
                          final isSelected = widget.selectedOutfit?.id == outfit.id;
                          return _buildOutfitCard(
                            outfit: outfit,
                            isSelected: isSelected,
                            subtitle: "Generated ${_formatDate(outfit.createdAt)}",
                            showStyleTag: true,
                          );
                        },
                      ),
                    ),

                  // --- SECTION 2: Recommended for Today's Weather ---
                  if (provider.isLoadingWeather)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Loading weather recommendations...",
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (currentWeather != null && weatherRecommended.isNotEmpty) ...[
                    _buildSectionHeader(
                      "RECOMMENDED FOR TODAY'S WEATHER",
                      trailing: "${currentWeather['condition'] ?? ''} • ${currentWeather['temperature']?.toString() ?? ''}°C",
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: weatherRecommended.length,
                        itemBuilder: (context, index) {
                          final outfit = weatherRecommended[index];
                          final isSelected = widget.selectedOutfit?.id == outfit.id;
                          return _buildOutfitCard(
                            outfit: outfit,
                            isSelected: isSelected,
                            subtitle: "Match for ${currentWeather['condition'] ?? 'Weather'}",
                          );
                        },
                      ),
                    ),
                  ],

                  // --- SECTION 3: All Outfits ---
                  _buildSectionHeader("ALL OUTFITS"),
                  
                  // Future Filter Bar
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: OutfitFilterType.values.length,
                      itemBuilder: (context, index) {
                        final filter = OutfitFilterType.values[index];
                        final isSelected = _activeFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(filter.displayName),
                            selected: isSelected,
                            selectedColor: AppColors.primaryLight.withOpacity(0.4),
                            checkmarkColor: AppColors.primary,
                            labelStyle: AppTextStyles.bodySmall.copyWith(
                              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : Colors.black.withOpacity(0.08),
                              width: 1,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _activeFilter = filter;
                              });
                              if (filter != OutfitFilterType.all) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${filter.displayName} filter is planned for a future update!"),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: AppColors.primaryDark,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (provider.isLoading && outfits.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  else if (filteredOutfits.isEmpty)
                    _buildEmptyState("No outfits found.")
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: filteredOutfits.length,
                        itemBuilder: (context, index) {
                          final outfit = filteredOutfits[index];
                          final isSelected = widget.selectedOutfit?.id == outfit.id;
                          return _buildGridOutfitCard(outfit, isSelected);
                        },
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

  Widget _buildSectionHeader(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primaryDark,
                letterSpacing: 1.5,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                trailing,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.03)),
        ),
        child: Center(
          child: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitCard({
    required Outfit outfit,
    required bool isSelected,
    required String subtitle,
    bool showStyleTag = false,
  }) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(outfit);
        Navigator.pop(context);
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black.withOpacity(0.04),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    outfit.name.isEmpty ? "Unnamed Look" : outfit.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
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
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildMiniImage(outfit.top?.imageUrl, "Top")),
                  const SizedBox(width: 4),
                  Expanded(child: _buildMiniImage(outfit.bottom?.imageUrl, "Bottom")),
                  const SizedBox(width: 4),
                  Expanded(child: _buildMiniImage(outfit.shoes?.imageUrl, "Shoes")),
                  const SizedBox(width: 4),
                  Expanded(child: _buildMiniImage(outfit.accessory?.imageUrl, "Acc")),
                ],
              ),
            ),
            if (showStyleTag && outfit.style != null && outfit.style!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  outfit.style!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGridOutfitCard(Outfit outfit, bool isSelected) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(outfit);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black.withOpacity(0.04),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    outfit.name.isEmpty ? "Unnamed Look" : outfit.name,
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
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMiniImage(outfit.top?.imageUrl, "Top"),
                  _buildMiniImage(outfit.bottom?.imageUrl, "Bottom"),
                  _buildMiniImage(outfit.shoes?.imageUrl, "Shoes"),
                  _buildMiniImage(outfit.accessory?.imageUrl, "Acc"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniImage(String? url, String label) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryLight.withOpacity(0.25)),
        ),
        child: url != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported_rounded,
                    color: AppColors.textLight,
                    size: 14,
                  ),
                ),
              )
            : Center(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 8,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}