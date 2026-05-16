import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../provider/outfit_provider.dart';
import '../../utils/outfit_theme.dart';
import '../widgets/outfit_grid.dart';
import '../widgets/outfit_loading.dart';
import 'create_outfit_page.dart';
import 'outfit_result_page.dart';

class OutfitPage extends StatefulWidget {
  const OutfitPage({super.key});

  @override
  State<OutfitPage> createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<OutfitProvider>().loadOutfits(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OutfitTheme.background,
      appBar: AppBar(
        title: const Text("My Outfits", style: OutfitTheme.titleStyle),
        backgroundColor: OutfitTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: OutfitTheme.accentColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OutfitResultPage()),
            ),
          ),
        ],
      ),
      body: Consumer<OutfitProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.outfits.isEmpty) {
            return const OutfitLoading();
          }

          if (provider.outfits.isEmpty) {
            return const Center(
              child: Text("No outfits saved yet.", style: OutfitTheme.subtitleStyle),
            );
          }

          return OutfitGrid(outfits: provider.outfits);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<OutfitProvider>().clearSelection();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateOutfitPage()),
          );
        },
        backgroundColor: OutfitTheme.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
