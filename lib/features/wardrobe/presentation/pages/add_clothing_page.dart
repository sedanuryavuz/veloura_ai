import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:veloura_ai/core/constants/enums/colors.dart';

import '../../../../core/constants/enums/categories.dart';
import '../../../../core/services/supabase_service.dart';
import '../provider/wardrobe_provider.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/image_picker_field.dart';

class AddClothingPage extends StatefulWidget {
  const AddClothingPage({super.key});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? image;

  final nameController = TextEditingController();

  ClothingCategory category = ClothingCategory.top;

  final _picker = ImagePicker();

  bool isProcessing = false;
  bool isAnalyzing = false;

  ClothingColor detectedColorEnum = ClothingColor.black;
  String detectedStyle = '';
  String detectedDescription = '';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // ---------------- AI ----------------
  Future<void> analyzeImage(File file) async {
    setState(() => isAnalyzing = true);

    final result = await context.read<WardrobeProvider>().analyzeClothing(file);

    if (result != null) {
      setState(() {
        nameController.text = result['name'] ?? '';

        detectedStyle = result['style'] ?? '';
        detectedDescription = result['description'] ?? '';

        category = ClothingCategoryExt.fromString(
          result['category'] ?? '',
        );

        detectedColorEnum = ClothingColorExt.fromString(
          result['color'] ?? '',
        );
      });
    }

    setState(() => isAnalyzing = false);
  }

  // ---------------- SAVE ----------------
  Future<void> save() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    if (image == null || nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await context.read<WardrobeProvider>().addItem(
      userId: userId,
      name: nameController.text,
      category: category,
      imageFile: image!,
      color: detectedColorEnum.name,
      style: detectedStyle,
      description: detectedDescription,
    );

    if (mounted) Navigator.pop(context);
  }

  // ---------------- IMAGE PROCESS ----------------
  Future<void> pickAndProcessImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    setState(() => isProcessing = true);

    final file = File(picked.path);

    final processed = await context.read<WardrobeProvider>().removeBackground(file);

    if (processed != null) {
      setState(() => image = processed);

      // 🔥 AI AUTO TRIGGER
      await analyzeImage(processed);
    }

    setState(() => isProcessing = false);
  }

  // ---------------- UI ----------------
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

                // IMAGE PICKER
                ImagePickerField(
                  image: image,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return SafeArea(
                          child: Wrap(
                            children: [

                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text("Gallery"),
                                onTap: () async {
                                  Navigator.pop(ctx);
                                  await pickAndProcessImage(ImageSource.gallery);
                                },
                              ),

                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("Camera"),
                                onTap: () async {
                                  Navigator.pop(ctx);
                                  await pickAndProcessImage(ImageSource.camera);
                                },
                              ),

                              ListTile(
                                leading: const Icon(Icons.visibility),
                                title: const Text("View Image"),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  if (image != null) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        child: Image.file(image!),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // NAME
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Item name",
                  ),
                ),

                const SizedBox(height: 12),

                // AI PREVIEW
                if (detectedStyle.isNotEmpty)
                  Text("Style: $detectedStyle"),
if (detectedDescription.isNotEmpty)
  Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      detectedDescription,
      style: const TextStyle(fontSize: 13),
    ),
  ),
                if (detectedDescription.isNotEmpty)
                  Text("AI: $detectedDescription"),

                const SizedBox(height: 16),

                // CATEGORY
                CategoryDropdown(
                  value: category,
                  onChanged: (v) => setState(() => category = v),
                ),

                const SizedBox(height: 12),

                // COLOR PICKER (AI + EDITABLE)
                DropdownButton<ClothingColor>(
                  value: detectedColorEnum,
                  items: ClothingColor.values.map((color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Text(color.displayName),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => detectedColorEnum = val);
                  },
                ),

                const SizedBox(height: 12),

                // STYLE EDIT (fallback)
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Style (AI or edit)",
                  ),
                  controller: TextEditingController(text: detectedStyle),
                  onChanged: (v) => detectedStyle = v,
                ),

                const Spacer(),

                // SAVE
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

          // LOADING OVERLAY
          if (isProcessing || isAnalyzing || provider.isLoading)
            const ColoredBox(
              color: Colors.black45,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}