import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  })  : _getWardrobeItems = getWardrobeItems,
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

  void _updateCaches() {
    _tops = _items.where((e) => e.category == ClothingCategory.top).toList();
    _bottoms = _items.where((e) => e.category == ClothingCategory.bottom).toList();
    _shoes = _items.where((e) => e.category == ClothingCategory.shoes).toList();
    
    if (_selectedCategory == ClothingCategory.all) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items.where((item) => item.category == _selectedCategory).toList();
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
      // Image upload handled by repository implementation
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
        color: item.color,
        style: item.style,
        description: item.description,
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
}