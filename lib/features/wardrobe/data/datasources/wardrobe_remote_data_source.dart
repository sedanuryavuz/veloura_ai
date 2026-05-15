import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/clothing_model.dart';
import 'storage_service.dart';
import 'background_removal_service.dart';
import '../../../chat/services/gemini_service.dart';

class WardrobeRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;
  final StorageService _storageService = StorageService();
  final BackgroundRemovalService _bgService = BackgroundRemovalService();
  final GeminiService _geminiService = GeminiService();

  Future<List<ClothingModel>> getItems(String userId) async {
    final response = await _client
        .from('wardrobe_items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((data) => ClothingModel.fromMap(data)).toList();
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
    return _geminiService.analyzeClothing(image);
  }

  Future<File?> removeBackground(File image) {
    return _bgService.removeBackground(image);
  }
}
