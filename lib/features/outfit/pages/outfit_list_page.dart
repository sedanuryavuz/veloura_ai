import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/outfit_controller.dart';
import '../utils/outfit_theme.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/outfit_card.dart';

class OutfitListPage extends StatelessWidget {
  const OutfitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OutfitTheme.background,
      body: Consumer<OutfitController>(
        builder: (context, controller, child) {
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text(
                  "Saved Outfits",
                  style: OutfitTheme.titleStyle,
                ),
                backgroundColor: OutfitTheme.background,
                elevation: 0,
                floating: true,
                centerTitle: false,
              ),
              if (controller.outfits.isEmpty)
                const SliverFillRemaining(
                  child: EmptyStateView(
                    title: "No outfits yet",
                    subtitle: "Create your first perfect look in the builder.",
                    icon: Icons.checkroom_outlined,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OutfitTheme.spacingM,
                    vertical: OutfitTheme.spacingS,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final outfit = controller.outfits[index];
                        return OutfitCard(
                          key: ValueKey(outfit.id),
                          outfit: outfit,
                        );
                      },
                      childCount: controller.outfits.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}