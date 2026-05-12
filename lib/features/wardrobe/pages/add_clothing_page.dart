import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/wardrobe_controller.dart';
import '../models/clothing_item_model.dart';
import '../services/image_service.dart';
import '../widgets/image_source_sheet.dart';

class AddClothingPage extends StatefulWidget {
  const AddClothingPage({super.key});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? selectedImage;

  final nameController = TextEditingController();

  String selectedCategory = 'top';

  final ImageService _imageService = ImageService();

  void saveItem() {
    if (selectedImage == null || nameController.text.trim().isEmpty) {
      return;
    }

    final item = ClothingItemModel(
      id: DateTime.now().toString(),

      imagePath: selectedImage!.path,

      name: nameController.text,

      category: selectedCategory.toLowerCase(),
    );

    context.read<WardrobeController>().addItem(item);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Clothing')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                ImageSourceSheet.show(
                  context: context,
                  onImagePicked: (image) {
                    setState(() {
                      selectedImage = image;
                    });
                  },
                );
              },

              child: Container(
                height: 220,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: selectedImage == null
                    ? const Icon(Icons.add_a_photo, size: 50)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
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
                onPressed: saveItem,

                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
