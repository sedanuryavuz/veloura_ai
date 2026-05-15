import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/enums/categories.dart';
import '../../wardrobe/providers/wardrobe_provider.dart';
import '../providers/outfit_provider.dart';
import '../utils/outfit_theme.dart';
import '../widgets/outfit_preview.dart';
import '../widgets/outfit_selector_grid.dart';

class OutfitBuilderPage extends StatefulWidget {
  const OutfitBuilderPage({super.key});

  @override
  State<OutfitBuilderPage> createState() => _OutfitBuilderPageState();
}

class _OutfitBuilderPageState extends State<OutfitBuilderPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        final userId = Supabase.instance.client.auth.currentUser!.id;
        context.read<WardrobeProvider>().loadItems(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final outfit = context.watch<OutfitProvider>();
    final provider = context.read<OutfitProvider>();

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
        title: Text(
          outfit.editingOutfitId != null ? "Edit Outfit" : "Outfit Builder",
          style: OutfitTheme.titleStyle,
        ),
        backgroundColor: OutfitTheme.background,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: OutfitTheme.accentColor,
        onPressed: outfit.isLoading ? null : () async {
          if (outfit.selectedTop == null &&
              outfit.selectedBottom == null &&
              outfit.selectedShoes == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select at least one item"),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          final userId = Supabase.instance.client.auth.currentUser!.id;
          await provider.saveOutfit(userId);

          if (mounted) {
            if (provider.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Outfit saved successfully"),
                behavior: SnackBarBehavior.floating,
              ),
            );

            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        },
        label: outfit.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                "Save Outfit",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
        icon: const Icon(Icons.check, color: Colors.white),
      ),
      body: Column(
        children: [
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
                    labelColor: OutfitTheme.accentColor,
                    unselectedLabelColor: OutfitTheme.textSecondary,
                    indicatorColor: OutfitTheme.accentColor,
                    indicatorWeight: 3,
                    labelStyle: OutfitTheme.labelStyle,
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