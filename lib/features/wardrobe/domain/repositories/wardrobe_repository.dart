import '../entities/clothing_item.dart';
import 'dart:io';

abstract class WardrobeRepository {
  Future<List<ClothingItem>> getItems(String userId);
  Future<ClothingItem> addItem(ClothingItem item);
  Future<ClothingItem> updateItem(ClothingItem item);
  Future<void> deleteItem(String id);
  
  // These might be needed if we want to move image/AI logic to repository
  Future<String> uploadImage(File file, String userId);
  Future<void> deleteImage(String imageUrl);
  Future<Map<String, dynamic>?> analyzeClothing(File image);
  Future<File?> removeBackground(File image);
}
