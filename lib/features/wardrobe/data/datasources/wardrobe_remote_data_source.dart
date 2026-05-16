import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/clothing_model.dart';
import '../../../outfit/data/datasources/storage_data_source.dart';
import '../../../outfit/data/datasources/background_removal_data_source.dart';
import '../../../outfit/data/datasources/outfit_ai_data_source.dart';

class WardrobeRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;
  final StorageDataSource _storageService = StorageDataSourceImpl(Supabase.instance.client);
  final BackgroundRemovalDataSource _bgService = BackgroundRemovalDataSourceImpl();
  final OutfitAiDataSource _aiService = OutfitAiDataSourceImpl();

  Future<List<ClothingModel>> getItems(String userId) async {
    final response = await _client
        .from('wardrobe_items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((data) => ClothingModel.fromMap(data)).toList();
  }

  Future<ClothingModel> addItem(ClothingModel item) async {
    final response = await _client
        .from('wardrobe_items')
        .insert(item.toMap())
        .select()
        .single();
        
    return ClothingModel.fromMap(response);
  }

  Future<ClothingModel> updateItem(ClothingModel item) async {
    final response = await _client
        .from('wardrobe_items')
        .update(item.toMap())
        .eq('id', item.id)
        .select()
        .single();
        
    return ClothingModel.fromMap(response);
  }

  Future<void> deleteItem(String id) async {
    await _client.from('wardrobe_items').delete().eq('id', id);
  }

  Future<String> uploadImage(File file, String userId) {
    return _storageService.uploadImage(file, userId);
  }

  Future<void> deleteImage(String imageUrl) {
    return _storageService.deleteImage(imageUrl);
  }

  Future<Map<String, dynamic>?> analyzeClothing(File image) {
    return _aiService.analyzeClothing(image);
  }

  Future<File?> removeBackground(File image) {
    return _bgService.removeBackground(image);
  }
}
