import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../../utils/outfit_theme.dart';
import '../provider/outfit_provider.dart';
import '../widgets/outfit_action_button.dart';
import '../widgets/outfit_loading.dart';
import '../../domain/entities/clothing_item.dart';

class OutfitResultPage extends StatefulWidget {
  const OutfitResultPage({super.key});

  @override
  State<OutfitResultPage> createState() => _OutfitResultPageState();
}

class _OutfitResultPageState extends State<OutfitResultPage> {
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

  Future<void> _generateAIOutfit() async {
    final wardrobe = context.read<WardrobeProvider>().items;
    final provider = context.read<OutfitProvider>();
    
    // Convert wardrobe items to domain ClothingItem if needed
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
      weather: {"temperature": 22, "description": "Sunny"}, // Default or fetch real weather
    );
  }

  @override
  Widget build(BuildContext context) {
    final outfit = context.watch<OutfitProvider>();

    return Scaffold(
      backgroundColor: OutfitTheme.background,
      appBar: AppBar(
        title: const Text("AI Stylist ✨", style: OutfitTheme.titleStyle),
        backgroundColor: OutfitTheme.background,
        elevation: 0,
      ),
      body: outfit.isLoading 
          ? const OutfitLoading()
          : Column(
              children: [
                if (outfit.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(outfit.error!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                Expanded(
                  child: Center(
                    child: _OutfitDisplay(outfit: outfit),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutfitActionButton(
                          label: "Generate New",
                          icon: Icons.auto_awesome,
                          onPressed: _generateAIOutfit,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (outfit.selectedTop != null)
                        Expanded(
                          child: OutfitActionButton(
                            label: "Save This",
                            icon: Icons.bookmark_border,
                            onPressed: () async {
                              final userId = SupabaseService.currentUserId ?? '';
                              await outfit.saveOutfit(userId);
                              if (mounted) Navigator.pop(context);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _OutfitDisplay extends StatelessWidget {
  final OutfitProvider outfit;
  const _OutfitDisplay({required this.outfit});

  @override
  Widget build(BuildContext context) {
    if (outfit.selectedTop == null && outfit.selectedBottom == null && outfit.selectedShoes == null) {
      return const Text("Tap generate to get an AI outfit recommendation!", textAlign: TextAlign.center);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildItem(outfit.selectedTop?.imageUrl),
        const SizedBox(height: 16),
        _buildItem(outfit.selectedBottom?.imageUrl),
        const SizedBox(height: 16),
        _buildItem(outfit.selectedShoes?.imageUrl, height: 80),
      ],
    );
  }

  Widget _buildItem(String? url, {double height = 150}) {
    if (url == null) return const SizedBox.shrink();
    return Container(
      height: height,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: OutfitTheme.borderRadiusL,
        boxShadow: OutfitTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: OutfitTheme.borderRadiusL,
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }
}
