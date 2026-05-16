import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/calendar_event_model.dart';

abstract class CalendarRemoteDataSource {
  Future<List<CalendarEventModel>> getEvents(String userId);
  Future<CalendarEventModel> addEvent(CalendarEventModel event);
  Future<void> updateEvent(CalendarEventModel event);
  Future<void> deleteEvent(String id);
}

class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<CalendarEventModel>> getEvents(String userId) async {
    final response = await _client
        .from('calendar_outfits')
        .select('*, outfits(*, outfit_items(*, wardrobe_items(*)))')
        .eq('user_id', userId)
        .order('selected_date', ascending: true);

    return response.map((data) => CalendarEventModel.fromMap(data)).toList();
  }

  @override
  Future<CalendarEventModel> addEvent(CalendarEventModel event) async {
    final response = await _client
        .from('calendar_outfits')
        .insert(event.toMap())
        .select('*, outfits(*, outfit_items(*, wardrobe_items(*)))')
        .single();
    
    return CalendarEventModel.fromMap(response);
  }

  @override
  Future<void> updateEvent(CalendarEventModel event) async {
    await _client
        .from('calendar_outfits')
        .update(event.toMap())
        .eq('id', event.id);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _client.from('calendar_outfits').delete().eq('id', id);
  }
}
