import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class GetEventsByDate {
  final CalendarRepository repository;

  GetEventsByDate(this.repository);

  Future<List<CalendarEvent>> call(String userId, DateTime date) async {
    return await repository.getEventsByDate(userId, date);
  }
}
