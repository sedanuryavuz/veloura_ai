import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/calendar_outfit_model.dart';

class CalendarRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<CalendarOutfitModel>> getOutfits(String userId) async {
    try {
      final response = await _client
          .from('calendar_outfits')
          .select('*, outfits(*, outfit_items(*, wardrobe_items(*)))')
          .eq('user_id', userId)
          .order('selected_date', ascending: true);

      return response.map((data) => CalendarOutfitModel.fromMap(data)).toList();
    } catch (e) {
      print('=== SUPABASE GET ERROR ===');
      print(e);
      rethrow;
    }
  }

  Future<CalendarOutfitModel> addOutfit(CalendarOutfitModel calendarOutfit) async {
    try {
      final payload = calendarOutfit.toMap();
      print('=== SUPABASE INSERT PAYLOAD ===');
      print(payload);

      final response = await _client
          .from('calendar_outfits')
          .insert(payload)
          .select('*, outfits(*, outfit_items(*, wardrobe_items(*)))')
          .single();
          
      print('=== SUPABASE INSERT SUCCESS ===');
      print(response);
      return CalendarOutfitModel.fromMap(response);
    } catch (e) {
      print('=== SUPABASE INSERT ERROR ===');
      print(e);
      rethrow;
    }
  }

  Future<void> deleteOutfit(String id) async {
    try {
      await _client.from('calendar_outfits').delete().eq('id', id);
    } catch (e) {
      print('=== SUPABASE DELETE ERROR ===');
      print(e);
      rethrow;
    }
  }
}
