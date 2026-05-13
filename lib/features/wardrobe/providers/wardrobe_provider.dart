import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/categories.dart';
import '../models/clothing_item_model.dart';
import '../repositories/wardrobe_repository.dart';
import '../services/storage_service.dart';

class WardrobeProvider extends ChangeNotifier {
  final WardrobeRepository _repository = WardrobeRepository();
  final StorageService _storageService = StorageService();

  List<ClothingItemModel> _items = [];
  List<ClothingItemModel> get items => _items;

  ClothingCategory _selectedCategory = ClothingCategory.all;
  ClothingCategory get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<ClothingItemModel> get filteredItems {
    if (_selectedCategory == ClothingCategory.all) return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  void changeCategory(ClothingCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadItems(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _items = await _repository.getItems(userId);
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
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final imageUrl = await _storageService.uploadImage(imageFile, userId);

      final newItem = ClothingItemModel(
        id: const Uuid().v4(),
        userId: userId,
        imageUrl: imageUrl,
        name: name,
        category: category,
        createdAt: DateTime.now(),
      );

      final addedItem = await _repository.addItem(newItem);
      _items.insert(0, addedItem);
      notifyListeners(); 
    } catch (e) {
      _error = 'Failed to add item: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateItem({
    required ClothingItemModel item,
    required String newName,
    required ClothingCategory newCategory,
    File? newImageFile,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      String imageUrl = item.imageUrl;

      if (newImageFile != null) {
        imageUrl = await _storageService.uploadImage(newImageFile, item.userId);
      }

      final updatedItem = item.copyWith(
        name: newName,
        category: newCategory,
        imageUrl: imageUrl,
      );

      final savedItem = await _repository.updateItem(updatedItem);
      
      final index = _items.indexWhere((e) => e.id == savedItem.id);
      if (index != -1) {
        _items[index] = savedItem;
        notifyListeners(); 
      }
    } catch (e) {
      _error = 'Failed to update item: $e';
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteItem(ClothingItemModel item) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteItem(item.id);
      await _storageService.deleteImage(item.imageUrl);
      
      _items.removeWhere((e) => e.id == item.id);
    } catch (e) {
      _error = 'Failed to delete item: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
