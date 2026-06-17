import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../domain/entities/calendar_event.dart';
import 'day_cell.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<CalendarEvent> events;
  final Function(DateTime, DateTime) onDaySelected;

  const CalendarGrid({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        boxShadow: AppDecorations.softShadow,
      ),
      child: TableCalendar(
        locale: Localizations.localeOf(context).toString(),
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2024),
        lastDay: DateTime.utc(2035),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTextStyles.h3,
          leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
          rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
          weekendStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final now = DateTime.now();
            final today = DateUtils.dateOnly(now);
            final cellDate = DateUtils.dateOnly(day);
            final hasEvent = events.any((e) => isSameDay(e.date, day));
            
            return DayCell(
              date: day,
              isToday: isSameDay(day, now),
              isPast: cellDate.isBefore(today),
              hasEvent: hasEvent,
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            final now = DateTime.now();
            final today = DateUtils.dateOnly(now);
            final cellDate = DateUtils.dateOnly(day);
            final hasEvent = events.any((e) => isSameDay(e.date, day));

            return DayCell(
              date: day,
              isSelected: true,
              isToday: isSameDay(day, now),
              isPast: cellDate.isBefore(today),
              hasEvent: hasEvent,
            );
          },
          todayBuilder: (context, day, focusedDay) {
            final hasEvent = events.any((e) => isSameDay(e.date, day));
            return DayCell(
              date: day,
              isToday: true,
              hasEvent: hasEvent,
            );
          },
        ),
      ),
    );
  }
}
