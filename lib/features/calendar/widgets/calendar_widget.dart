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
          selectedDecoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final cellDate = DateTime(day.year, day.month, day.day);
            
            if (cellDate.isBefore(today)) {
              return Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      const Icon(Icons.lock_outline, size: 10, color: Colors.grey),
                    ],
                  ),
                ),
              );
            }
            return null;
          },
          selectedBuilder: (context, day, focusedDay) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final cellDate = DateTime(day.year, day.month, day.day);
            
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: cellDate.isBefore(today) ? Colors.grey : Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}