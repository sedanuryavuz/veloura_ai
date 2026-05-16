import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/enums/colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/widgets/v_delete_dialog.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/enums/clothing_form_mode.dart';
import '../provider/wardrobe_provider.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/image_picker_field.dart';
import '../widgets/image_source_sheet.dart';

class ClothingFormPage extends StatefulWidget {
  final ClothingFormMode mode;
  final ClothingItem? item;

  const ClothingFormPage({super.key, required this.mode, this.item});

  @override
  State<ClothingFormPage> createState() => _ClothingFormPageState();
}

class _ClothingFormPageState extends State<ClothingFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController styleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<WardrobeProvider>();

    if (widget.mode == ClothingFormMode.add) {
      provider.clearDraft();
    } else {
      final item = widget.item!;

      provider.startEditing(item);

      nameController.text = item.name;
      styleController.text = item.style;
      descriptionController.text = item.description;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    styleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final provider = context.read<WardrobeProvider>();
    final userId = SupabaseService.currentUserId;

    if (userId == null) return;

    final success = widget.mode == ClothingFormMode.add
        ? await provider.saveDraftItem(userId)
        : await provider.saveEdit(userId);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else if (provider.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.error!)));
    }
  }

  void _onImageTap() {
    final provider = context.read<WardrobeProvider>();

    final currentImage = widget.mode == ClothingFormMode.edit
        ? provider.editImage
        : provider.draftImage;

    ImageSourceSheet.show(
      context: context,
      currentImage: currentImage,
      networkImageUrl: widget.mode == ClothingFormMode.edit
          ? widget.item?.imageUrl
          : null,
      onSourceSelected: (source) {
        if (widget.mode == ClothingFormMode.add) {
          provider.pickAndProcessImage(source);
        } else {
          provider.pickEditImage(source);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();

    final bool isEdit = widget.mode == ClothingFormMode.edit;

    final category = isEdit ? provider.editCategory : provider.draftCategory;

    final selectedColor = isEdit ? provider.editColor : provider.draftColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Clothing" : "Add Clothing"),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: () {
                VDeleteDialog.show(
                  context,
                  title: "Delete Item?",
                  content: "Do you want to permanently remove this item from your wardrobe?",
                  onDelete: () async {
                    await provider.deleteItem(widget.item!);
                    if (mounted) Navigator.pop(context);
                  },
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), // Added bottom padding
            child: Column(
              children: [
                const SizedBox(height: 16),

                /// IMAGE PICKER BUTTON
                ImagePickerField(
                  onTap: _onImageTap,
                  imageWidget: isEdit
                      ? (provider.editImage != null
                            ? Image.file(provider.editImage!, fit: BoxFit.contain)
                            : Image.network(
                                widget.item!.imageUrl,
                                fit: BoxFit.contain,
                              ))
                      : (provider.draftImage != null
                            ? Image.file(
                                provider.draftImage!,
                                fit: BoxFit.contain,
                              )
                            : const Center(
                                child: Icon(Icons.add_a_photo, size: 50),
                              )),
                ),
                const SizedBox(height: 24),

                /// NAME
                TextField(
                  controller: nameController,
                  onChanged: (v) {
                    if (isEdit) {
                      provider.updateEditName(v);
                    } else {
                      provider.updateDraftName(v);
                    }
                  },
                  decoration: const InputDecoration(labelText: "Item Name"),
                ),

                const SizedBox(height: 16),

                /// STYLE
                TextField(
                  controller: styleController,
                  onChanged: (v) {
                    if (isEdit) {
                      provider.updateEditStyle(v);
                    } else {
                      provider.updateDraftStyle(v);
                    }
                  },
                  decoration: const InputDecoration(labelText: "Style"),
                ),

                const SizedBox(height: 16),

                /// COLOR
                DropdownButtonFormField<ClothingColor>(
                  value: selectedColor,
                  decoration: const InputDecoration(labelText: "Color"),
                  items: ClothingColor.values.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c.displayName),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v == null) return;

                    if (isEdit) {
                      provider.updateEditColor(v);
                    } else {
                      provider.updateDraftColor(v);
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// DESCRIPTION
                TextField(
                  controller: descriptionController,
                  onChanged: (v) {
                    if (isEdit) {
                      provider.updateEditDescription(v);
                    } else {
                      provider.updateDraftDescription(v);
                    }
                  },
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description"),
                ),

                const SizedBox(height: 16),

                /// CATEGORY
                CategoryDropdown(
                  value: category,
                  onChanged: (v) {
                    if (isEdit) {
                      provider.updateEditCategory(v);
                    } else {
                      provider.updateDraftCategory(v);
                    }
                  },
                ),

                const SizedBox(height: 40),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isEdit ? "Update Item" : "Save Item",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                
                if (isEdit) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        VDeleteDialog.show(
                          context,
                          title: "Delete Item?",
                          content: "Do you want to permanently remove this item from your wardrobe?",
                          onDelete: () async {
                            await provider.deleteItem(widget.item!);
                            if (mounted) Navigator.pop(context);
                          },
                        );
                      },
                      child: const Text(
                        "Delete Item",
                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// LOADING
          if (provider.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
