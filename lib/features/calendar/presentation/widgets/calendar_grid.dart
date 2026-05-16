import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'day_cell.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const CalendarGrid({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .75),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TableCalendar(
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2024),
        lastDay: DateTime.utc(2035),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final now = DateTime.now();
            final today = DateUtils.dateOnly(now);
            final cellDate = DateUtils.dateOnly(day);
            
            return DayCell(
              date: day,
              isToday: isSameDay(day, now),
              isPast: cellDate.isBefore(today),
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            final now = DateTime.now();
            final today = DateUtils.dateOnly(now);
            final cellDate = DateUtils.dateOnly(day);

            return DayCell(
              date: day,
              isSelected: true,
              isToday: isSameDay(day, now),
              isPast: cellDate.isBefore(today),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return DayCell(
              date: day,
              isToday: true,
            );
          },
        ),
      ),
    );
  }
}
