import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/wardrobe_controller.dart';
import '../models/clothing_item_model.dart';

class EditClothingPage extends StatefulWidget {
  final ClothingItemModel item;

  const EditClothingPage({super.key, required this.item});

  @override
  State<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends State<EditClothingPage> {
  late TextEditingController nameController;

  late String selectedCategory;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.item.name);

    selectedCategory = widget.item.category;
  }

  void saveChanges() async {
    final updatedItem = ClothingItemModel(
      id: widget.item.id,
      imagePath: widget.item.imagePath,
      name: nameController.text,
      category: selectedCategory,
    );

    await context.read<WardrobeController>().updateItem(updatedItem);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Clothing')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Image.file(
                File(widget.item.imagePath),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),

            const SizedBox(height: 20),

            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,

              items: const [
                DropdownMenuItem(value: 'top', child: Text('Top')),

                DropdownMenuItem(value: 'bottom', child: Text('Bottom')),

                DropdownMenuItem(value: 'shoes', child: Text('Shoes')),

                DropdownMenuItem(
                  value: 'accessories',
                  child: Text('Accessories'),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: saveChanges,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
