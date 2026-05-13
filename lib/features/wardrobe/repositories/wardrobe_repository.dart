import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/clothing_item_model.dart';

class WardrobeRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<ClothingItemModel>> getItems(String userId) async {
    final response = await _client
        .from('wardrobe_items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((data) => ClothingItemModel.fromMap(data)).toList();
  }

  Future<ClothingItemModel> addItem(ClothingItemModel item) async {
    final response = await _client
        .from('wardrobe_items')
        .insert(item.toMap())
        .select()
        .single();
        
    return ClothingItemModel.fromMap(response);
  }

  Future<ClothingItemModel> updateItem(ClothingItemModel item) async {
    final response = await _client
        .from('wardrobe_items')
        .update(item.toMap())
        .eq('id', item.id)
        .select()
        .single();
        
    return ClothingItemModel.fromMap(response);
  }

  Future<void> deleteItem(String id) async {
    await _client.from('wardrobe_items').delete().eq('id', id);
  }
}
