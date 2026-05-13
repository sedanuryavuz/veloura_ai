import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {

  final DateTime focusedDay;
  final DateTime selectedDay;

  final Function(DateTime, DateTime)
      onDaySelected;

  const CalendarWidget({
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
        color: Colors.white.withOpacity(.75),

        borderRadius:
            BorderRadius.circular(28),
      ),

      child: TableCalendar(
        focusedDay: focusedDay,

        firstDay: DateTime.utc(2024),
        lastDay: DateTime.utc(2035),

        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },

        onDaySelected: onDaySelected,

        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),

        calendarStyle: CalendarStyle(

          selectedDecoration:
              const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),

          todayDecoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}