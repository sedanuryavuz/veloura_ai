import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/enums/clothing_form_mode.dart';
import '../provider/wardrobe_provider.dart';
import '../widgets/wardrobe_grid.dart';
import 'add_clothing_page.dart';
import '../widgets/category_filter.dart';
import 'clothing_form_page.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userId = SupabaseService.currentUserId ?? '';
    if (userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WardrobeProvider>().loadItems(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Wardrobe'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ClothingFormPage(mode: ClothingFormMode.add),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          CategoryFilter(
            selected: provider.selectedCategory,
            onSelected: (value) => provider.changeCategory(value),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(WardrobeProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return _ErrorView(message: provider.error!, onRetry: _loadData);
    }

    return WardrobeGrid(provider: provider);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
