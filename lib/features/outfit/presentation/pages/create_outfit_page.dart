import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/enums/categories.dart';
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
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<WardrobeProvider>().loadItems(userId);
      }
      
      final outfit = context.read<OutfitProvider>();
      if (outfit.editingOutfitId != null) {
        _nameController.text = outfit.outfits.firstWhere((e) => e.id == outfit.editingOutfitId).name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final outfit = context.watch<OutfitProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          outfit.editingOutfitId != null ? "EDIT LOOK" : "NEW LOOK",
          style: AppTextStyles.h3.copyWith(letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(40),
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white.withOpacity(0.08),
      Colors.white.withOpacity(0.02),
    ],
  ),
),
        child: SafeArea(
          child: Column(
            children: [
              // Outfit Canvas Section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _OutfitCanvas(outfit: outfit),
                ),
              ),

              // Controls Section
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                          child: TextField(
                            controller: _nameController,
                            onChanged: (value) => setState(() {}),
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: "Give this look a name...",
                              hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: 4,
                            child: Column(
                              children: [
                                TabBar(
                                  dividerColor: Colors.transparent,
                                  labelColor: AppColors.accent,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: AppColors.accent,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                  tabs: const [
                                    Tab(text: "TOPS"),
                                    Tab(text: "BOTTOMS"),
                                    Tab(text: "SHOES"),
                                    Tab(text: "ACCESSORIES"),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _ClothingSelector(
                                        items: wardrobe.items.where((i) => i.category == ClothingCategory.top).toList(),
                                        onSelect: (item) => outfit.selectTop(_mapToClothingItem(item)),
                                        selectedId: outfit.selectedTop?.id,
                                      ),
                                      _ClothingSelector(
                                        items: wardrobe.items.where((i) => i.category == ClothingCategory.bottom).toList(),
                                        onSelect: (item) => outfit.selectBottom(_mapToClothingItem(item)),
                                        selectedId: outfit.selectedBottom?.id,
                                      ),
                                      _ClothingSelector(
                                        items: wardrobe.items.where((i) => i.category == ClothingCategory.shoes).toList(),
                                        onSelect: (item) => outfit.selectShoes(_mapToClothingItem(item)),
                                        selectedId: outfit.selectedShoes?.id,
                                      ),
                                      _ClothingSelector(
                                        items: wardrobe.items.where((i) => i.category == ClothingCategory.accessories).toList(),
                                        onSelect: (item) => outfit.selectAccessory(_mapToClothingItem(item)),
                                        selectedId: outfit.selectedAccessory?.id,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          onPressed: outfit.isLoading ? null : () async {
            final userId = SupabaseService.currentUserId ?? '';
            if (userId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please sign in to save outfits")),
              );
              return;
            }

            final name = _nameController.text.trim().isEmpty ? "My Outfit" : _nameController.text.trim();
            await outfit.saveOutfit(userId, name);
            
            if (mounted) {
              if (outfit.error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Outfit saved successfully!")),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: ${outfit.error}"),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
          backgroundColor: AppColors.primary,
          elevation: 10,
          label: outfit.isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text("SAVE OUTFIT", style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          icon: const Icon(Icons.check_rounded, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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


class _OutfitCanvas extends StatefulWidget {
  final OutfitProvider outfit;
  const _OutfitCanvas({super.key, required this.outfit});

  @override
  State<_OutfitCanvas> createState() => _OutfitCanvasState();
}

class _OutfitCanvasState extends State<_OutfitCanvas> {
  // Local state for item positions and scales
  final Map<String, Offset> _positions = {
    'top': const Offset(0, -60),
    'bottom': const Offset(0, 60),
    'shoes': const Offset(0, 160),
    'accessories': const Offset(100, -100),
  };

  final Map<String, double> _scales = {
    'top': 1.0,
    'bottom': 1.0,
    'shoes': 1.0,
    'accessories': 1.0,
  };

  @override
  Widget build(BuildContext context) {
    final outfit = widget.outfit;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Label
          Center(
            child: Text(
              "CANVAS",
              style: AppTextStyles.h1.copyWith(
                color: Colors.white.withOpacity(0.03),
                fontSize: 80,
                letterSpacing: 20,
              ),
            ),
          ),

          // Render selected items
          if (outfit.selectedTop != null)
            _TransformableItem(
              key: ValueKey('top_${outfit.selectedTop!.id}'),
              imageUrl: outfit.selectedTop!.imageUrl,
              initialOffset: _positions['top']!,
              initialScale: _scales['top']!,
              onTransformChanged: (offset, scale) {
                _positions['top'] = offset;
                _scales['top'] = scale;
              },
            ),
          if (outfit.selectedBottom != null)
            _TransformableItem(
              key: ValueKey('bottom_${outfit.selectedBottom!.id}'),
              imageUrl: outfit.selectedBottom!.imageUrl,
              initialOffset: _positions['bottom']!,
              initialScale: _scales['bottom']!,
              onTransformChanged: (offset, scale) {
                _positions['bottom'] = offset;
                _scales['bottom'] = scale;
              },
            ),
          if (outfit.selectedShoes != null)
            _TransformableItem(
              key: ValueKey('shoes_${outfit.selectedShoes!.id}'),
              imageUrl: outfit.selectedShoes!.imageUrl,
              initialOffset: _positions['shoes']!,
              initialScale: _scales['shoes']!,
              onTransformChanged: (offset, scale) {
                _positions['shoes'] = offset;
                _scales['shoes'] = scale;
              },
            ),
          if (outfit.selectedAccessory != null)
            _TransformableItem(
              key: ValueKey('accessories_${outfit.selectedAccessory!.id}'),
              imageUrl: outfit.selectedAccessory!.imageUrl,
              initialOffset: _positions['accessories']!,
              initialScale: _scales['accessories']!,
              onTransformChanged: (offset, scale) {
                _positions['accessories'] = offset;
                _scales['accessories'] = scale;
              },
            ),

        
        ],
      ),
    );
  }
}

class _TransformableItem extends StatefulWidget {
  final String imageUrl;
  final Offset initialOffset;
  final double initialScale;
  final Function(Offset, double) onTransformChanged;

  const _TransformableItem({
    super.key,
    required this.imageUrl,
    required this.initialOffset,
    required this.initialScale,
    required this.onTransformChanged,
  });

  @override
  State<_TransformableItem> createState() => _TransformableItemState();
}

class _TransformableItemState extends State<_TransformableItem> {
  late Offset _offset;
  late double _scale;
  late double _baseScale;

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;
    _scale = widget.initialScale;
    _baseScale = _scale;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + _offset.dx - 100,
      top: 150 + _offset.dy - 100,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: (details) {
          _baseScale = _scale;
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale = (_baseScale * details.scale).clamp(0.4, 3.0);
            _offset += details.focalPointDelta;
          });
          widget.onTransformChanged(_offset, _scale);
        },
        child: Transform.scale(
          scale: _scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
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
    if (items.isEmpty) {
      return Center(
        child: Text(
          "No items found",
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item.id == selectedId;
        return GestureDetector(
          onTap: () => onSelect(item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected ? [
                      BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)
                    ] : [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Image.network(item.imageUrl, fit: BoxFit.contain),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
