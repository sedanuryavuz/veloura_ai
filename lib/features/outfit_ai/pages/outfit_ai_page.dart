import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veloura_ai/core/services/supabase_service.dart';

import '../../outfit/providers/outfit_provider.dart';
import '../../outfit/utils/outfit_theme.dart';
import '../../outfit/widgets/outfit_preview.dart';


import '../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../controllers/outfit_ai_controller.dart';
import '../helpers/outfit_mapper.dart';

import '../widgets/ai_error_banner.dart';
import '../widgets/outfit_ai_actions.dart';
import '../widgets/outfit_category_tabs.dart';

class OutfitAiPage extends StatefulWidget {
  const OutfitAiPage({super.key});

  @override
  State<OutfitAiPage> createState() =>
      _OutfitAiPageState();
}

class _OutfitAiPageState
    extends State<OutfitAiPage> {
  String get _userId => SupabaseService.currentUserId ?? '';

  @override
  void initState() {
    super.initState();

    if (_userId.isNotEmpty) {
      Future.microtask(() {
        context.read<WardrobeProvider>().loadItems(_userId);
      });
    }
  }

  Future<void> _generateAIOutfit() async {
    final wardrobe =
        context.read<WardrobeProvider>().items;

    final aiController =
        context.read<OutfitAiController>();

    final outfitProvider =
        context.read<OutfitProvider>();

    await aiController.generateOutfit(
      wardrobe: wardrobe,
    );

    final result = aiController.result;

    if (result == null) return;

    OutfitMapper.applyAiResult(
      aiItems: result.items,
      wardrobe: wardrobe,
      outfitProvider: outfitProvider,
    );
  }

  Future<void> _saveOutfit() async {
    try {
      await context
          .read<OutfitProvider>()
          .saveOutfit(_userId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "AI Outfit kaydedildi ✨",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("SAVE OUTFIT ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe =
        context.watch<WardrobeProvider>();

    final outfit =
        context.watch<OutfitProvider>();

    final ai =
        context.watch<OutfitAiController>();

    final hasSelection =
        outfit.selectedTop != null ||
            outfit.selectedBottom != null ||
            outfit.selectedShoes != null;

    return Scaffold(
      backgroundColor: OutfitTheme.background,

      appBar: AppBar(
        title: const Text("AI Outfit ✨"),
        backgroundColor: OutfitTheme.background,
        elevation: 0,
      ),

      floatingActionButton: OutfitAiActions(
        isLoading: ai.isLoading,
        hasSelection: hasSelection,
        onGenerate: _generateAIOutfit,
        onSave: _saveOutfit,
      ),

      body: Column(
        children: [
          AiErrorBanner(
            error: ai.error,
          ),

          Expanded(
            flex: 3,
            child: OutfitPreview(
              outfit: outfit,
            ),
          ),

          Expanded(
            flex: 4,
            child: OutfitCategoryTabs(
              wardrobe: wardrobe,
              outfit: outfit,
            ),
          ),
        ],
      ),
    );
  }
}