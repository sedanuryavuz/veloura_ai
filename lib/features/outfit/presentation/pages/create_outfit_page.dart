import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../../utils/outfit_theme.dart';
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
      backgroundColor: OutfitTheme.background,
      appBar: AppBar(
        title: Text(
          outfit.editingOutfitId != null ? "Edit Outfit" : "Create Outfit",
          style: OutfitTheme.titleStyle,
        ),
        backgroundColor: OutfitTheme.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _OutfitPreviewWidget(outfit: outfit),
          ),
          Expanded(
            flex: 4,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: OutfitTheme.accentColor,
                    unselectedLabelColor: OutfitTheme.textSecondary,
                    indicatorColor: OutfitTheme.accentColor,
                    tabs: [
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: outfit.isLoading ? null : () async {
          final userId = SupabaseService.currentUserId ?? '';
          await outfit.saveOutfit(userId);
          if (mounted && outfit.error == null) {
            Navigator.pop(context);
          }
        },
        backgroundColor: OutfitTheme.accentColor,
        label: outfit.isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
            : const Text("Save Outfit", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }

  ClothingItem _mapToClothingItem(dynamic item) {
    // Mapping from Wardrobe entity to Outfit entity if they are different
    // Assuming they have same fields for now or use specific mapping
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
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OutfitTheme.cardBackground,
        borderRadius: OutfitTheme.borderRadiusL,
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
        color: OutfitTheme.background,
        borderRadius: OutfitTheme.borderRadiusM,
        border: Border.all(color: OutfitTheme.borderSubtle),
      ),
      child: imageUrl == null 
          ? Center(child: Text(label, style: OutfitTheme.labelStyle))
          : ClipRRect(
              borderRadius: OutfitTheme.borderRadiusM,
              child: Image.network(imageUrl, fit: BoxFit.cover),
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
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item.id == selectedId;
        return GestureDetector(
          onTap: () => onSelect(item),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: OutfitTheme.borderRadiusM,
              border: Border.all(
                color: isSelected ? OutfitTheme.accentColor : OutfitTheme.borderSubtle,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: OutfitTheme.borderRadiusM,
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
