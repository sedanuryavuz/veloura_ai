import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/categories.dart';
import '../../../core/services/supabase_service.dart';
import '../providers/wardrobe_provider.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/image_picker_field.dart';
import '../widgets/image_source_sheet.dart';

class AddClothingPage extends StatefulWidget {
  const AddClothingPage({super.key});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? image;
  final nameController = TextEditingController();
  ClothingCategory category = ClothingCategory.top;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    if (image == null || nameController.text.isEmpty) return;

    await context.read<WardrobeProvider>().addItem(
      userId: userId,
      name: nameController.text,
      category: category,
      imageFile: image!,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Clothing")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ImagePickerField(
                  image: image,
                  onTap: () {
                    ImageSourceSheet.show(
                      context: context,
                      onImagePicked: (img) => setState(() => image = img),
                    );
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Item name"),
                ),

                const SizedBox(height: 20),

                CategoryDropdown(
                  value: category,
                  onChanged: (v) => setState(() => category = v),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : save,
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ),

          if (provider.isLoading)
            const ColoredBox(
              color: Colors.black45,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}