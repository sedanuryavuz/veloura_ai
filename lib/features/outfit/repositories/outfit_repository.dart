import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/outfit_model.dart';

class OutfitRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<OutfitModel>> getOutfits(String userId) async {
    final response = await _client
        .from('outfits')
        .select('*, outfit_items(*, wardrobe_items(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((data) => OutfitModel.fromMap(data)).toList();
  }

  Future<OutfitModel> createOutfit(OutfitModel outfit) async {
    final outfitResponse = await _client
        .from('outfits')
        .insert(outfit.toMap())
        .select()
        .single();
    
    final outfitItems = outfit.items.map((item) => {
      'outfit_id': outfit.id,
      'clothing_item_id': item.id,
    }).toList();
    
    if (outfitItems.isNotEmpty) {
      await _client.from('outfit_items').insert(outfitItems);
    }
    
    // We fetch the created outfit with its items again to have the full joined response
    // Or we could just construct it locally. Constructing locally:
    return outfit.copyWith(createdAt: DateTime.parse(outfitResponse['created_at'] as String));
  }

  Future<OutfitModel> updateOutfit(OutfitModel outfit) async {
    await _client
        .from('outfits')
        .update(outfit.toMap())
        .eq('id', outfit.id);
        
    // Clear old relations
    await _client.from('outfit_items').delete().eq('outfit_id', outfit.id);
    
    // Insert new relations
    final outfitItems = outfit.items.map((item) => {
      'outfit_id': outfit.id,
      'clothing_item_id': item.id,
    }).toList();
    
    if (outfitItems.isNotEmpty) {
      await _client.from('outfit_items').insert(outfitItems);
    }
    
    return outfit;
  }

  Future<void> deleteOutfit(String id) async {
    // Note: If you have ON DELETE CASCADE set up in Supabase for outfit_items,
    // deleting the outfit is enough. We delete from outfit_items first to be safe.
    await _client.from('outfit_items').delete().eq('outfit_id', id);
    await _client.from('outfits').delete().eq('id', id);
  }
}
