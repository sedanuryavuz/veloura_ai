import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/enums/colors.dart';
import '../../../../core/constants/enums/categories.dart';
import '../../domain/entities/clothing_item.dart';
import '../../domain/usecases/get_wardrobe_items.dart';
import '../../domain/usecases/add_clothing_item.dart';
import '../../domain/usecases/update_clothing_item.dart';
import '../../domain/usecases/analyze_clothing.dart';
import '../../domain/usecases/remove_background.dart';
import '../../domain/repositories/wardrobe_repository.dart';

class WardrobeProvider extends ChangeNotifier {
  final GetWardrobeItems _getWardrobeItems;
  final AddClothingItem _addClothingItem;
  final UpdateClothingItem _updateClothingItem;
  final DeleteClothingItem _deleteClothingItem;
  final AnalyzeClothing _analyzeClothing;
  final RemoveBackground _removeBackground;
  final WardrobeRepository _repository;

  WardrobeProvider({
    required GetWardrobeItems getWardrobeItems,
    required AddClothingItem addClothingItem,
    required UpdateClothingItem updateClothingItem,
    required DeleteClothingItem deleteClothingItem,
    required AnalyzeClothing analyzeClothing,
    required RemoveBackground removeBackground,
    required WardrobeRepository repository,
  }) : _getWardrobeItems = getWardrobeItems,
       _addClothingItem = addClothingItem,
       _updateClothingItem = updateClothingItem,
       _deleteClothingItem = deleteClothingItem,
       _analyzeClothing = analyzeClothing,
       _removeBackground = removeBackground,
       _repository = repository;

  List<ClothingItem> _items = [];
  List<ClothingItem> get items => _items;

  List<ClothingItem> _tops = [];
  List<ClothingItem> get tops => _tops;

  List<ClothingItem> _bottoms = [];
  List<ClothingItem> get bottoms => _bottoms;

  List<ClothingItem> _shoes = [];
  List<ClothingItem> get shoes => _shoes;

  ClothingCategory _selectedCategory = ClothingCategory.all;
  ClothingCategory get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<ClothingItem> _filteredItems = [];
  List<ClothingItem> get filteredItems => _filteredItems;

  // --- Draft Item State for Adding ---
  File? _draftImage;
  File? get draftImage => _draftImage;

  String _draftName = '';
  String get draftName => _draftName;

  ClothingCategory _draftCategory = ClothingCategory.top;
  ClothingCategory get draftCategory => _draftCategory;

  ClothingColor _draftColor = ClothingColor.black;
  ClothingColor get draftColor => _draftColor;

  String _draftStyle = '';
  String get draftStyle => _draftStyle;

  String _draftDescription = '';
  String get draftDescription => _draftDescription;

  bool _isProcessingImage = false;
  bool get isProcessingImage => _isProcessingImage;

  bool _isAnalyzingImage = false;
  bool get isAnalyzingImage => _isAnalyzingImage;

  final _picker = ImagePicker();
  String? get editImageUrl => _editingItem?.imageUrl;
  // --- Edit Item State ---
  ClothingItem? _editingItem;
  ClothingItem? get editingItem => _editingItem;

  String _editName = '';
  String get editName => _editName;

  ClothingCategory _editCategory = ClothingCategory.top;
  ClothingCategory get editCategory => _editCategory;

  File? _editImage;
  File? get editImage => _editImage;

  ClothingColor _editColor = ClothingColor.black;
  ClothingColor get editColor => _editColor;

  String _editStyle = '';
  String get editStyle => _editStyle;

  String _editDescription = '';
  String get editDescription => _editDescription;

  void _updateCaches() {
    _tops = _items.where((e) => e.category == ClothingCategory.top).toList();
    _bottoms = _items
        .where((e) => e.category == ClothingCategory.bottom)
        .toList();
    _shoes = _items.where((e) => e.category == ClothingCategory.shoes).toList();

    if (_selectedCategory == ClothingCategory.all) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where((item) => item.category == _selectedCategory)
          .toList();
    }
  }

  void changeCategory(ClothingCategory category) {
    _selectedCategory = category;
    _updateCaches();
    notifyListeners();
  }

  Future<void> loadItems(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _items = await _getWardrobeItems(userId);
      _updateCaches();
    } catch (e) {
      _error = 'Failed to load items: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addItem({
    required String userId,
    required String name,
    required ClothingCategory category,
    required File imageFile,
    required String color,
    required String style,
    required String description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final imageUrl = await _repository.uploadImage(imageFile, userId);

      final newItem = ClothingItem(
        id: const Uuid().v4(),
        userId: userId,
        imageUrl: imageUrl,
        name: name,
        category: category,
        createdAt: DateTime.now(),
        color: color,
        style: style,
        description: description,
      );

      final addedItem = await _addClothingItem(newItem);
      _items.insert(0, addedItem);
      _updateCaches();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add item: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateItem({
    required ClothingItem item,
    required String newName,
    required ClothingCategory newCategory,
    required String newColor,
    required String newStyle,
    required String newDescription,
    File? newImageFile,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      String imageUrl = item.imageUrl;

      if (newImageFile != null) {
        imageUrl = await _repository.uploadImage(newImageFile, item.userId);
      }

      final updatedItem = ClothingItem(
        id: item.id,
        userId: item.userId,
        imageUrl: imageUrl,
        name: newName,
        category: newCategory,
        createdAt: item.createdAt,
        color: newColor,
        style: newStyle,
        description: newDescription,
      );

      final savedItem = await _updateClothingItem(updatedItem);

      final index = _items.indexWhere((e) => e.id == savedItem.id);
      if (index != -1) {
        _items[index] = savedItem;
        _updateCaches();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update item: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteItem(ClothingItem item) async {
    _setLoading(true);
    _clearError();

    try {
      await _deleteClothingItem(item.id);
      await _repository.deleteImage(item.imageUrl);

      _items.removeWhere((e) => e.id == item.id);
      _updateCaches();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete item: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> analyzeClothing(File image) async {
    return _analyzeClothing(image);
  }

  Future<File?> removeBackground(File image) async {
    return _removeBackground(image);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // --- Draft Item Methods (Add) ---

  void updateDraftName(String name) {
    _draftName = name;
  }

  void updateDraftCategory(ClothingCategory category) {
    _draftCategory = category;
    notifyListeners();
  }

  void updateDraftColor(ClothingColor color) {
    _draftColor = color;
    notifyListeners();
  }

  void updateDraftStyle(String style) {
    _draftStyle = style;
  }

  void updateDraftDescription(String v) {
    _draftDescription = v;
  }

  Future<void> pickAndProcessImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    _isProcessingImage = true;
    notifyListeners();

    try {
      final file = File(picked.path);
      final processed = await _removeBackground(file);

      if (processed != null) {
        _draftImage = processed;
        notifyListeners();
        await analyzeDraftImage();
      }
    } catch (e) {
      _error = 'Image processing failed: $e';
    } finally {
      _isProcessingImage = false;
      notifyListeners();
    }
  }

  Future<void> analyzeDraftImage() async {
    if (_draftImage == null) return;

    _isAnalyzingImage = true;
    notifyListeners();

    try {
      final result = await _analyzeClothing(_draftImage!);
      if (result != null) {
        _draftName = result['name'] ?? _draftName;
        _draftStyle = result['style'] ?? _draftStyle;
        _draftDescription = result['description'] ?? _draftDescription;
        _draftCategory = ClothingCategoryExt.fromString(
          result['category'] ?? '',
        );
        _draftColor = ClothingColorExt.fromString(result['color'] ?? '');
      }
    } catch (e) {
      _error = "AI limit reached. Please try again later or enter details manually.";
    } finally {
      _isAnalyzingImage = false;
      notifyListeners();
    }
  }

  Future<bool> saveDraftItem(String userId) async {
    if (_draftImage == null || _draftName.isEmpty) {
      _error = 'Please provide an image and a name';
      notifyListeners();
      return false;
    }

    try {
      await addItem(
        userId: userId,
        name: _draftName,
        category: _draftCategory,
        imageFile: _draftImage!,
        color: _draftColor.name,
        style: _draftStyle,
        description: _draftDescription,
      );
      clearDraft();
      return true;
    } catch (e) {
      return false;
    }
  }

  void clearDraft() {
    _draftImage = null;
    _draftName = '';
    _draftCategory = ClothingCategory.top;
    _draftColor = ClothingColor.black;
    _draftStyle = '';
    _draftDescription = '';
    _isProcessingImage = false;
    _isAnalyzingImage = false;
    _error = null;
    notifyListeners();
  }

  // --- Edit Item Methods ---

  void startEditing(ClothingItem item) {
    _editingItem = item;
    _editName = item.name;
    _editCategory = item.category;

    // EKLE
    _editColor = item.color.isNotEmpty
        ? ClothingColorExt.fromString(item.color)
        : ClothingColor.black;
    _editStyle = item.style;
    _editDescription = item.description;

    _editImage = null;
    notifyListeners();
  }

  void updateEditName(String name) {
    _editName = name;
  }

  void updateEditCategory(ClothingCategory category) {
    _editCategory = category;
    notifyListeners();
  }

  void updateEditStyle(String style) {
    _editStyle = style;
  }

  void updateEditColor(ClothingColor color) {
    _editColor = color;
  }

  void updateEditDescription(String description) {
    _editDescription = description;
  }

  Future<void> pickEditImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    _editImage = File(picked.path);
    notifyListeners();
  }

  Future<bool> saveEdit(String userId) async {
    if (_editingItem == null) return false;

    try {
      await updateItem(
        item: _editingItem!,
        newName: _editName,
        newCategory: _editCategory,
        newImageFile: _editImage,
        newColor: _editColor.name,
        newStyle: _editStyle,
        newDescription: _editDescription,
      );
      _editingItem = null;
      return true;
    } catch (e) {
      return false;
    }
  }
}
