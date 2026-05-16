import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class AddCalendarEvent {
  final CalendarRepository repository;

  AddCalendarEvent(this.repository);

  Future<CalendarEvent> call(CalendarEvent event) async {
    return await repository.addEvent(event);
  }
}
