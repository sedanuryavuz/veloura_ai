import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:veloura_ai/core/services/supabase_service.dart';
import 'package:veloura_ai/features/outfit_ai/pages/outfit_ai_page.dart';

import '../providers/outfit_provider.dart';
import '../utils/outfit_theme.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/outfit_card.dart';
import 'outfit_builder_page.dart';

class OutfitListPage extends StatefulWidget {
  const OutfitListPage({super.key});

  @override
  State<OutfitListPage> createState() => _OutfitListPageState();
}

class _OutfitListPageState extends State<OutfitListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final userId = SupabaseService.currentUserId ?? '';
        if (userId.isNotEmpty) {
          context.read<OutfitProvider>().loadOutfits(userId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OutfitTheme.background,
      body: Consumer<OutfitProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.outfits.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: OutfitTheme.accentColor),
            );
          }

          if (provider.error != null && provider.outfits.isEmpty) {
            return Center(
              child: Text(
                'Error: ${provider.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text("Saved Outfits", style: OutfitTheme.titleStyle),
                backgroundColor: OutfitTheme.background,
                elevation: 0,
                floating: true,
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    child: const Text("AI Outfit ✨"),
                    onPressed: () {
                      //final wardrobe = context.read<WardrobeProvider>().items;

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OutfitAiPage()),
                      );
                    },
                  ),
                ),
              ),
              if (provider.outfits.isEmpty)
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
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final outfit = provider.outfits[index];
                      return OutfitCard(
                        key: ValueKey(outfit.id),
                        outfit: outfit,
                      );
                    }, childCount: provider.outfits.length),
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<OutfitProvider>().clearSelection();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OutfitBuilderPage()),
          );
        },
        backgroundColor: OutfitTheme.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
