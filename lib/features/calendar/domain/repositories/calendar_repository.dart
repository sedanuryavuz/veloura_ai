import '../entities/calendar_event.dart';

abstract class CalendarRepository {
  Future<List<CalendarEvent>> getEvents(String userId);
  Future<CalendarEvent> addEvent(CalendarEvent event);
  Future<void> updateEvent(CalendarEvent event);
  Future<void> deleteEvent(String id);
  Future<List<CalendarEvent>> getEventsByDate(String userId, DateTime date);
  Future<List<CalendarEvent>> generateAISchedule(String userId, String prompt);
}
