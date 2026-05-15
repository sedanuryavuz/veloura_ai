import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/enums/categories.dart';
import '../models/clothing_item_model.dart';
import '../providers/wardrobe_provider.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/image_source_sheet.dart';

class EditClothingPage extends StatefulWidget {
  final ClothingItemModel item;

  const EditClothingPage({super.key, required this.item});

  @override
  State<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends State<EditClothingPage> {
  late TextEditingController nameController;
  late ClothingCategory selectedCategory;

  File? newImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    selectedCategory = widget.item.category;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    final provider = context.read<WardrobeProvider>();

    if (nameController.text.trim().isEmpty) return;

    await provider.updateItem(
      item: widget.item,
      newName: nameController.text.trim(),
      newCategory: selectedCategory,
      newImageFile: newImage,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Clothing")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: provider.isLoading
                      ? null
                      : () {
                          ImageSourceSheet.show(
                            context: context,
                            onImagePicked: (file) {
                              setState(() {
                                newImage = file;
                              });
                            },
                          );
                        },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: newImage != null
                          ? Image.file(newImage!, fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: widget.item.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  const Center(child: CircularProgressIndicator()),
                              errorWidget: (_, __, ___) =>
                                  const Icon(Icons.error),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Item name",
                  ),
                  enabled: !provider.isLoading,
                ),

                const SizedBox(height: 20),

                CategoryDropdown(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : saveChanges,
                    child: const Text("Save Changes"),
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