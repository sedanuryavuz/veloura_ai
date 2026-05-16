import 'calendar_event.dart';

class CalendarDay {
  final DateTime date;
  final List<CalendarEvent> events;

  const CalendarDay({
    required this.date,
    required this.events,
  });

  bool get hasEvents => events.isNotEmpty;
}
