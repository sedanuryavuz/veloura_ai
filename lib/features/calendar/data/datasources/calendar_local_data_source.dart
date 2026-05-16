import '../models/calendar_event_model.dart';

abstract class CalendarLocalDataSource {
  Future<void> cacheEvents(List<CalendarEventModel> events);
  Future<List<CalendarEventModel>> getCachedEvents();
}

class CalendarLocalDataSourceImpl implements CalendarLocalDataSource {
  @override
  Future<void> cacheEvents(List<CalendarEventModel> events) async {
    // TODO: Implement local storage (Hive/SharedPreferences)
  }

  @override
  Future<List<CalendarEventModel>> getCachedEvents() async {
    // TODO: Implement local storage (Hive/SharedPreferences)
    return [];
  }
}
