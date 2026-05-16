import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../provider/outfit_provider.dart';
import '../../domain/entities/clothing_item.dart';

class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({super.key});

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<WardrobeProvider>().loadItems(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final outfit = context.watch<OutfitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(outfit.editingOutfitId != null ? "Edit Outfit" : "Create Outfit"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: _OutfitPreviewWidget(outfit: outfit),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TabBar(
                        dividerColor: Colors.transparent,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textLight,
                        indicatorColor: AppColors.primary,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(text: "Tops"),
                          Tab(text: "Bottoms"),
                          Tab(text: "Shoes"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _ClothingSelector(
                              items: wardrobe.items.where((i) => i.category.name == 'top').toList(),
                              onSelect: (item) => outfit.selectTop(_mapToClothingItem(item)),
                              selectedId: outfit.selectedTop?.id,
                            ),
                            _ClothingSelector(
                              items: wardrobe.items.where((i) => i.category.name == 'bottom').toList(),
                              onSelect: (item) => outfit.selectBottom(_mapToClothingItem(item)),
                              selectedId: outfit.selectedBottom?.id,
                            ),
                            _ClothingSelector(
                              items: wardrobe.items.where((i) => i.category.name == 'shoes').toList(),
                              onSelect: (item) => outfit.selectShoes(_mapToClothingItem(item)),
                              selectedId: outfit.selectedShoes?.id,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: outfit.isLoading ? null : () async {
            final userId = SupabaseService.currentUserId ?? '';
            await outfit.saveOutfit(userId);
            if (mounted && outfit.error == null) {
              Navigator.pop(context);
            }
          },
          backgroundColor: AppColors.primary,
          label: outfit.isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
              : const Text("Save Outfit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.check_rounded, color: Colors.white),
        ),
      ),
    );
  }

  ClothingItem _mapToClothingItem(dynamic item) {
    return ClothingItem(
      id: item.id,
      userId: item.userId,
      imageUrl: item.imageUrl,
      name: item.name,
      category: item.category,
      createdAt: item.createdAt,
      color: item.color,
      style: item.style,
      description: item.description,
    );
  }
}

class _OutfitPreviewWidget extends StatelessWidget {
  final OutfitProvider outfit;
  const _OutfitPreviewWidget({required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItem(outfit.selectedTop?.imageUrl, "Top"),
          _buildItem(outfit.selectedBottom?.imageUrl, "Bottom"),
          _buildItem(outfit.selectedShoes?.imageUrl, "Shoes"),
        ],
      ),
    );
  }

  Widget _buildItem(String? imageUrl, String label) {
    return Container(
      height: 80,
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDecorations.softShadow,
      ),
      child: imageUrl == null 
          ? Center(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
    );
  }
}

class _ClothingSelector extends StatelessWidget {
  final List<dynamic> items;
  final Function(dynamic) onSelect;
  final String? selectedId;

  const _ClothingSelector({
    required this.items,
    required this.onSelect,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item.id == selectedId;
        return GestureDetector(
          onTap: () => onSelect(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8)
              ] : AppDecorations.softShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSelected ? 10 : 12),
              child: Image.network(item.imageUrl, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}
