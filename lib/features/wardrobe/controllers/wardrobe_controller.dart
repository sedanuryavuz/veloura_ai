import 'package:flutter/material.dart';

import '../models/clothing_item_model.dart';
import '../services/wardrobe_storage_service.dart';

class WardrobeController extends ChangeNotifier {
  final WardrobeStorageService _storage =
      WardrobeStorageService();

  List<ClothingItemModel> items = [];

  String selectedCategory = 'all';

  void loadItems() {
    items = _storage.loadItems();
    notifyListeners();
  }

  Future<void> addItem(
    ClothingItemModel item,
  ) async {
    items.add(item);

    await _storage.saveItems(items);

    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    items.removeWhere((e) => e.id == id);

    await _storage.saveItems(items);

    notifyListeners();
  }

  Future<void> updateItem(
  ClothingItemModel updatedItem,
) async {
  final index = items.indexWhere(
    (e) => e.id == updatedItem.id,
  );

  if (index != -1) {
    items[index] = updatedItem;

    await _storage.saveItems(items);

    notifyListeners();
  }
}

  List<ClothingItemModel> get filteredItems {
  if (selectedCategory == 'all') {
    return items;
  }

  return items.where((item) {
    return item.category == selectedCategory;
  }).toList();
}
void changeCategory(String category) {
  selectedCategory = category;
  notifyListeners();
}
}