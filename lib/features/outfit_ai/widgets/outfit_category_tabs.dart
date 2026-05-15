import 'package:flutter/material.dart';

import '../../outfit/providers/outfit_provider.dart';
import '../../outfit/widgets/outfit_selector_grid.dart';
import '../../wardrobe/presentation/provider/wardrobe_provider.dart';

class OutfitCategoryTabs extends StatelessWidget {
  final WardrobeProvider wardrobe;
  final OutfitProvider outfit;

  const OutfitCategoryTabs({
    super.key,
    required this.wardrobe,
    required this.outfit,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        title: "TOPS",
        items: wardrobe.tops,
        onTap: outfit.selectTop,
        selected: outfit.selectedTop,
      ),

      (
        title: "BOTTOMS",
        items: wardrobe.bottoms,
        onTap: outfit.selectBottom,
        selected: outfit.selectedBottom,
      ),

      (
        title: "SHOES",
        items: wardrobe.shoes,
        onTap: outfit.selectShoes,
        selected: outfit.selectedShoes,
      ),
    ];

    return DefaultTabController(
      length: tabs.length,

      child: Column(
        children: [
          TabBar(
            tabs: tabs
                .map(
                  (tab) => Tab(
                    text: tab.title,
                  ),
                )
                .toList(),
          ),

          Expanded(
            child: TabBarView(
              children: tabs.map((tab) {
                return OutfitSelectorGrid(
                  items: tab.items,
                  onTap: (item) => tab.onTap,
                  selectedItem: tab.selected,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}