import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../provider/outfit_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<OutfitProvider>().loadOutfits(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Outfits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OutfitResultPage()),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 96), // Fixed: Higher margin from bottom nav
        child: FloatingActionButton(
          onPressed: () {
            context.read<OutfitProvider>().clearSelection();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateOutfitPage()),
            );
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Consumer<OutfitProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.outfits.isEmpty) {
                return const OutfitLoading();
              }

              if (provider.outfits.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 60), // Fixed: Offsetting for bottom nav
                    child: Text("No outfits saved yet."),
                  ),
                );
              }

              return OutfitGrid(outfits: provider.outfits);
            },
          ),
        ),
      ),
    );
  }
}
