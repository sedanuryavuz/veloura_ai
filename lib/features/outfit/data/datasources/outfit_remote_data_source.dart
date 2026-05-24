import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/outfit_model.dart';

abstract class OutfitRemoteDataSource {
  Future<List<OutfitModel>> getOutfits(String userId);
  Future<OutfitModel> createOutfit(OutfitModel outfit);
  Future<OutfitModel> updateOutfit(OutfitModel outfit);
  Future<void> deleteOutfit(String id);
}

class OutfitRemoteDataSourceImpl implements OutfitRemoteDataSource {
  final SupabaseClient _client;

  OutfitRemoteDataSourceImpl(this._client);

  @override
  Future<List<OutfitModel>> getOutfits(String userId) async {
    final response = await _client
        .from('outfits')
        .select('*, outfit_items(*, wardrobe_items(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((data) => OutfitModel.fromMap(data)).toList();
  }

  @override
  Future<OutfitModel> createOutfit(OutfitModel outfit) async {
    // Remove ID if it's a new outfit to let database generate it (if needed)
    final map = outfit.toMap();
    if (outfit.id.isEmpty || outfit.id.length > 20) { // Simple check for auto-gen IDs
       // map.remove('id'); // Keep it if we want to try our generated ID first
    }

    final outfitResponse = await _client
        .from('outfits')
        .insert(map)
        .select()
        .single();
    
    final savedId = outfitResponse['id'];
    
    final outfitItems = outfit.items.map((item) => {
      'outfit_id': savedId,
      'clothing_item_id': item.id,
    }).toList();
    
    if (outfitItems.isNotEmpty) {
      await _client.from('outfit_items').insert(outfitItems);
    }
    
    return OutfitModel.fromMap({
      ...outfitResponse,
      'outfit_items': outfit.items.map((item) => {
        'wardrobe_items': item.toMap()
      }).toList(),
    });
  }

  @override
  Future<OutfitModel> updateOutfit(OutfitModel outfit) async {
    await _client
        .from('outfits')
        .update(outfit.toMap())
        .eq('id', outfit.id);
        
    await _client.from('outfit_items').delete().eq('outfit_id', outfit.id);
    
    final outfitItems = outfit.items.map((item) => {
      'outfit_id': outfit.id,
      'clothing_item_id': item.id,
    }).toList();
    
    if (outfitItems.isNotEmpty) {
      await _client.from('outfit_items').insert(outfitItems);
    }
    
    return outfit;
  }

  @override
  Future<void> deleteOutfit(String id) async {
    await _client.from('outfit_items').delete().eq('outfit_id', id);
    await _client.from('outfits').delete().eq('id', id);
  }
}
