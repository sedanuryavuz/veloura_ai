import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/wardrobe_controller.dart';
import '../widgets/clothing_card.dart';
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

    Future.microtask(() {
      context.read<WardrobeController>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WardrobeController>();

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
            selected: controller.selectedCategory,
            onSelected: (value) {
              controller.changeCategory(value);
            },
          ),

          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: controller.filteredItems.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),

              itemBuilder: (context, index) {
                final item = controller.items[index];

                return ClothingCard(
                  item: item,
                  onDelete: () {
                    controller.deleteItem(item.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
