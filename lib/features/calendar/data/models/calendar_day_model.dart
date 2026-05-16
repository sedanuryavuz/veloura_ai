import '../../domain/entities/calendar_day.dart';
import 'calendar_event_model.dart';

class CalendarDayModel extends CalendarDay {
  const CalendarDayModel({
    required super.date,
    required List<CalendarEventModel> super.events,
  });

  factory CalendarDayModel.fromEntity(CalendarDay entity) {
    return CalendarDayModel(
      date: entity.date,
      events: entity.events.map((e) => CalendarEventModel.fromEntity(e)).toList(),
    );
  }
}
