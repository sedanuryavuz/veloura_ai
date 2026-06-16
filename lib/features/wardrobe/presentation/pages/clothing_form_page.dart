import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/enums/colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/widgets/v_delete_dialog.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/enums/clothing_form_mode.dart';
import '../provider/wardrobe_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/image_picker_field.dart';
import '../widgets/image_source_sheet.dart';
import 'clothing_photo_tutorial_page.dart';

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

    if (widget.mode == ClothingFormMode.edit) {
      final item = widget.item!;
      nameController.text = item.name;
      styleController.text = item.style;
      descriptionController.text = item.description;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WardrobeProvider>();
      if (widget.mode == ClothingFormMode.add) {
        provider.clearDraft();
      } else {
        provider.startEditing(widget.item!);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    styleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _syncControllersWithProvider() {
    final provider = context.read<WardrobeProvider>();
    final isEdit = widget.mode == ClothingFormMode.edit;

    if (isEdit) {
      nameController.text = provider.editName;
      styleController.text = provider.editStyle;
      descriptionController.text = provider.editDescription;
    } else {
      nameController.text = provider.draftName;
      styleController.text = provider.draftStyle;
      descriptionController.text = provider.draftDescription;
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      onSourceSelected: (source) async {
        bool hasPermission = false;
        if (source == ImageSource.gallery) {
          hasPermission = await PermissionService.instance.requestGalleryPermission(context);
        } else if (source == ImageSource.camera) {
          hasPermission = await PermissionService.instance.requestCameraPermission(context);
        }

        if (!context.mounted) return;
        if (!hasPermission) return;

        if (source == ImageSource.camera) {
          final completed = PreferencesService.instance.getBool('camera_onboarding_completed', defaultValue: false);
          if (!completed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClothingPhotoTutorialPage(
                  onCompleted: () async {
                    await PreferencesService.instance.setBool('camera_onboarding_completed', true);
                    if (context.mounted) {
                      Navigator.pop(context); // Dismiss tutorial page
                      _triggerImagePick(source);
                    }
                  },
                ),
              ),
            );
            return;
          }
        }

        _triggerImagePick(source);
      },
    );
  }

  void _triggerImagePick(ImageSource source) {
    final provider = context.read<WardrobeProvider>();
    if (widget.mode == ClothingFormMode.add) {
      provider.pickAndProcessImage(source);
    } else {
      provider.pickEditImage(source);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WardrobeProvider>();
    final bool isEdit = widget.mode == ClothingFormMode.edit;

    // Show error snackbar for AI limits
    if (provider.error != null && (provider.error!.contains("AI limit") || provider.error!.contains("failed"))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      });
    }

    final category = isEdit ? provider.editCategory : provider.draftCategory;
    final selectedColor = isEdit ? provider.editColor : provider.draftColor;
    final hasImage = isEdit ? (provider.editImage != null || widget.item?.imageUrl != null) : provider.draftImage != null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// IMAGE PREVIEW
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
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
                                            child: Icon(Icons.add_a_photo, size: 40, color: AppColors.primary),
                                          )),
                            ),
                            if (provider.isProcessingImage || provider.isAnalyzingImage)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        provider.isAnalyzingImage ? "AI Analyzing..." : "Processing...",
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// AI AUTO-FILL BUTTON
                    if (hasImage && !provider.isAnalyzingImage)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          height: 36,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              print("AI BUTTON PRESSED - MODE: ${widget.mode}");
                              if (isEdit) {
                                await provider.analyzeEditImage();
                              } else {
                                await provider.analyzeDraftImage();
                              }
                              if (mounted) _syncControllersWithProvider();
                            },
                            icon: const Icon(Icons.auto_awesome, size: 16),
                            label: const Text("AI Auto-Fill", style: TextStyle(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ),

                    /// FORM FIELDS
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          TextField(
                            controller: nameController,
                            onChanged: (v) => isEdit ? provider.updateEditName(v) : provider.updateDraftName(v),
                            decoration: const InputDecoration(labelText: "Item Name", prefixIcon: Icon(Icons.title, size: 20)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: styleController,
                                  onChanged: (v) => isEdit ? provider.updateEditStyle(v) : provider.updateDraftStyle(v),
                                  decoration: const InputDecoration(labelText: "Style", prefixIcon: Icon(Icons.style, size: 20)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonFormField<ClothingColor>(
                                  value: selectedColor,
                                  decoration: const InputDecoration(labelText: "Color", prefixIcon: Icon(Icons.color_lens, size: 20)),
                                  items: ClothingColor.values.map((c) => DropdownMenuItem(value: c, child: Text(c.displayName))).toList(),
                                  onChanged: (v) {
                                    if (v != null) isEdit ? provider.updateEditColor(v) : provider.updateDraftColor(v);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descriptionController,
                            onChanged: (v) => isEdit ? provider.updateEditDescription(v) : provider.updateDraftDescription(v),
                            maxLines: 2,
                            decoration: const InputDecoration(labelText: "Description", prefixIcon: Icon(Icons.description, size: 20)),
                          ),
                          const SizedBox(height: 12),
                          CategorySelector(
                            value: category,
                            onChanged: (v) => isEdit ? provider.updateEditCategory(v) : provider.updateDraftCategory(v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// SAVE / UPDATE BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: provider.isLoading ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          isEdit ? "Update Clothing" : "Save to Wardrobe",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    if (isEdit)
                      TextButton(
                        onPressed: () {
                          VDeleteDialog.show(
                            context,
                            title: "Delete Item?",
                            content: "Do you want to permanently remove this item?",
                            onDelete: () async {
                              await provider.deleteItem(widget.item!);
                              if (mounted) Navigator.pop(context);
                            },
                          );
                        },
                        child: const Text("Delete Item", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
