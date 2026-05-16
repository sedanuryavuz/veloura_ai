import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class UpdateCalendarEvent {
  final CalendarRepository repository;

  UpdateCalendarEvent(this.repository);

  Future<void> call(CalendarEvent event) async {
    return await repository.updateEvent(event);
  }
}
