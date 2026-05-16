import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class GetCalendarEvents {
  final CalendarRepository repository;

  GetCalendarEvents(this.repository);

  Future<List<CalendarEvent>> call(String userId) async {
    return await repository.getEvents(userId);
  }
}
