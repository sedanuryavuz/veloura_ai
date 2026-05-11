import 'package:hive/hive.dart';

import '../models/clothing_item_model.dart';

class WardrobeStorageService {
  final Box box = Hive.box('wardrobe');

  Future<void> saveItems(
    List<ClothingItemModel> items,
  ) async {
    final data = items.map((e) {
      return {
        'id': e.id,
        'imagePath': e.imagePath,
        'name': e.name,
        'category': e.category,
      };
    }).toList();

    await box.put('items', data);
  }

  List<ClothingItemModel> loadItems() {
    final data = box.get('items', defaultValue: []);

    return List<Map>.from(data).map((item) {
      return ClothingItemModel(
        id: item['id'],
        imagePath: item['imagePath'],
        name: item['name'],
        category: item['category'],
      );
    }).toList();
  }
}