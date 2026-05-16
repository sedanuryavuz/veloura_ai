import '../repositories/calendar_repository.dart';

class DeleteCalendarEvent {
  final CalendarRepository repository;

  DeleteCalendarEvent(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteEvent(id);
  }
}
