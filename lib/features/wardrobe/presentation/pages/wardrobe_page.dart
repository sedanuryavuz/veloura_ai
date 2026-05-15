import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/core/services/supabase_service.dart';

import '../provider/wardrobe_provider.dart';
import '../widgets/wardrobe_grid.dart';
import 'add_clothing_page.dart';
import '../widgets/category_filter.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  @override
  void initState() {
    super.initState();
    final userId = SupabaseService.currentUserId ?? '';

    if (userId.isNotEmpty) {
      Future.microtask(() {
        context.read<WardrobeProvider>().loadItems(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Wardrobe')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClothingPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          CategoryFilter(
            selected: provider.selectedCategory,
            onSelected: (value) {
              provider.changeCategory(value);
            },
          ),

          const SizedBox(height: 16),
          
          if (provider.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (provider.error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(provider.error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final userId = SupabaseService.currentUserId ?? '';
                        if (userId.isNotEmpty) {
                          provider.loadItems(userId);
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(child: WardrobeGrid(provider: provider)),
        ],
      ),
    );
  }
}
