import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../provider/outfit_provider.dart';
import '../widgets/outfit_action_button.dart';
import '../widgets/outfit_loading.dart';
import '../widgets/outfit_name_dialog.dart';
import '../../domain/entities/clothing_item.dart';
import '../widgets/glass_container.dart';

class OutfitResultPage extends StatefulWidget {
  const OutfitResultPage({super.key});

  @override
  State<OutfitResultPage> createState() => _OutfitResultPageState();
}

class _OutfitResultPageState extends State<OutfitResultPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<WardrobeProvider>().loadItems(userId);
      }
    });
  }

  Future<void> _generateAIOutfit() async {
    final wardrobe = context.read<WardrobeProvider>().items;
    final provider = context.read<OutfitProvider>();
    
    final List<ClothingItem> domainWardrobe = wardrobe.map((item) => ClothingItem(
      id: item.id,
      userId: item.userId,
      imageUrl: item.imageUrl,
      name: item.name,
      category: item.category,
      createdAt: item.createdAt,
      color: item.color,
      style: item.style,
      description: item.description,
    )).toList();

    await provider.generateAiOutfit(
      wardrobe: domainWardrobe,
    );
    
  }

  Future<void> _saveOutfit() async {
    final provider = context.read<OutfitProvider>();
    final userId = SupabaseService.currentUserId ?? '';
    
    if (userId.isEmpty) return;

    final name = await showDialog<String>(
      context: context,
      builder: (context) => OutfitNameDialog(initialName: provider.aiName ?? "New Look"),
    );

    if (name != null && name.isNotEmpty) {
      await provider.saveOutfit(userId, name);
      if (mounted) {
        if (provider.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Outfit '$name' saved!"),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to save: ${provider.error}"),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final outfit = context.watch<OutfitProvider>();
    final hasOutfit = outfit.selectedTop != null || outfit.selectedBottom != null || outfit.selectedShoes != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("AI Stylist ✨", style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          ),
        ),
        child: outfit.isLoading 
            ? const OutfitLoading()
            : SafeArea(
                child: Column(
                  children: [
                    if (outfit.error != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GlassContainer(
                          child: Text(
                            outfit.error!,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                          ),
                        ),
                      ),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            if (hasOutfit) ...[
                              const SizedBox(height: 20),
                              Text(
                                outfit.aiName?.toUpperCase() ?? "CURATED LOOK",
                                style: AppTextStyles.h2.copyWith(
                                  letterSpacing: 2,
                                  color: AppColors.primaryDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (outfit.aiStyle != null)
                                Text(
                                  outfit.aiStyle!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(height: 40),
                              _OutfitPreview(
                                key: ValueKey('${outfit.selectedTop?.id}_${outfit.selectedBottom?.id}'),
                                outfit: outfit,
                              ),
                              const SizedBox(height: 40),
                              if (outfit.aiReason != null)
                                GlassContainer(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.tips_and_updates_outlined, color: AppColors.primaryDark, size: 20),
                                          const SizedBox(width: 8),
                                          Text("STYLIST NOTE", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        outfit.aiReason!,
                                        style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                            ] else
                              const _EmptyState(),
                            const SizedBox(height: 100), // Space for bottom buttons
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: OutfitActionButton(
                label: "Generate New",
                icon: Icons.auto_awesome_rounded,
                onPressed: _generateAIOutfit,
                isLoading: outfit.isLoading,
                color: AppColors.primary,
              ),
            ),
            if (hasOutfit) ...[
              const SizedBox(width: 16),
              Expanded(
                child: OutfitActionButton(
                  label: "Save This",
                  icon: Icons.bookmark_border_rounded,
                  onPressed: _saveOutfit,
                  isLoading: outfit.isLoading,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OutfitPreview extends StatefulWidget {
  final OutfitProvider outfit;
  const _OutfitPreview({super.key, required this.outfit});

  @override
  State<_OutfitPreview> createState() => _OutfitPreviewState();
}

class _OutfitPreviewState extends State<_OutfitPreview> {
  // Local state for item positions and scales (matching CreateOutfitPage default layout)
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
    
    return Center(
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Canvas Watermark
              Center(
                child: Text(
                  "CANVAS",
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white.withOpacity(0.02),
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
        ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_mosaic_rounded, size: 80, color: Colors.black),
          const SizedBox(height: 24),
          Text(
            "Ready for a fresh look?",
            style: AppTextStyles.h3.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 12),
          Text(
            "Tap the button below and let the AI stylist\ncurate a perfect outfit from your wardrobe.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black, height: 1.5),
          ),
        ],
      ),
    );
  }
}
