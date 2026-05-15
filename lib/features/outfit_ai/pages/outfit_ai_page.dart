import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:veloura_ai/features/outfit/providers/outfit_provider.dart';
import 'package:veloura_ai/features/outfit/utils/outfit_theme.dart';
import 'package:veloura_ai/features/outfit/widgets/outfit_preview.dart';
import 'package:veloura_ai/features/outfit/widgets/outfit_selector_grid.dart';

import '../../../core/constants/enums/categories.dart';
import '../../wardrobe/providers/wardrobe_provider.dart';
import '../controllers/outfit_ai_controller.dart';

class OutfitAiPage extends StatefulWidget {
  const OutfitAiPage({super.key});

  @override
  State<OutfitAiPage> createState() => _OutfitAiPageState();
}

class _OutfitAiPageState extends State<OutfitAiPage> {
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      context.read<WardrobeProvider>().loadItems(userId);
    });
  }

  Future<void> generateAIOutfit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final wardrobe = context.read<WardrobeProvider>().items;

      await context
          .read<OutfitAiController>()
          .generateOutfit(wardrobe: wardrobe);

      final result = context.read<OutfitAiController>().result;

      if (result == null) {
        throw Exception("AI result null");
      }

      final outfit = context.read<OutfitProvider>();

      outfit.clearSelection();

      for (final item in result["items"]) {
        final category = item["category"];

        final wardrobeItem = wardrobe.firstWhere(
          (e) => e.id == item["id"],
          orElse: () => wardrobe.first,
        );

        if (category == "top") outfit.selectTop(wardrobeItem);
        if (category == "bottom") outfit.selectBottom(wardrobeItem);
        if (category == "shoes") outfit.selectShoes(wardrobeItem);
      }
    } catch (e) {
      error = e.toString();

      debugPrint("AI ERROR: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("AI Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final outfit = context.watch<OutfitProvider>();

    final tops = wardrobe.items
        .where((e) => e.category == ClothingCategory.top)
        .toList();

    final bottoms = wardrobe.items
        .where((e) => e.category == ClothingCategory.bottom)
        .toList();

    final shoes = wardrobe.items
        .where((e) => e.category == ClothingCategory.shoes)
        .toList();

    return Scaffold(
      backgroundColor: OutfitTheme.background,

      appBar: AppBar(
        title: const Text("AI Outfit ✨"),
        backgroundColor: OutfitTheme.background,
        elevation: 0,
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: "ai_generate",
            onPressed: isLoading ? null : generateAIOutfit,
            backgroundColor: OutfitTheme.accentColor,
            label: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Generate AI"),
            icon: isLoading ? null : const Icon(Icons.auto_awesome),
          ),

          const SizedBox(height: 10),

          if (outfit.selectedTop != null ||
              outfit.selectedBottom != null ||
              outfit.selectedShoes != null)
            FloatingActionButton.extended(
              heroTag: "ai_save",
              backgroundColor: Colors.green,
              onPressed: () async {
                final userId =
                    Supabase.instance.client.auth.currentUser!.id;

                await context.read<OutfitProvider>().saveOutfit(userId);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("AI Outfit kaydedildi ✨"),
                  ),
                );

                Navigator.pop(context);
              },
              label: const Text("Save Outfit"),
              icon: const Icon(Icons.check),
            ),
        ],
      ),

      body: Column(
        children: [
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          Expanded(
            flex: 3,
            child: OutfitPreview(outfit: outfit),
          ),

          Expanded(
            flex: 4,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: "TOPS"),
                      Tab(text: "BOTTOMS"),
                      Tab(text: "SHOES"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        OutfitSelectorGrid(
                          items: tops,
                          onTap: outfit.selectTop,
                          selectedItem: outfit.selectedTop,
                        ),
                        OutfitSelectorGrid(
                          items: bottoms,
                          onTap: outfit.selectBottom,
                          selectedItem: outfit.selectedBottom,
                        ),
                        OutfitSelectorGrid(
                          items: shoes,
                          onTap: outfit.selectShoes,
                          selectedItem: outfit.selectedShoes,
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
    );
  }
}