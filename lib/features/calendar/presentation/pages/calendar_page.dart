import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../provider/calendar_provider.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';
import '../widgets/event_card.dart';
import '../widgets/empty_event_state.dart';
import '../widgets/add_event_button.dart';
import '../widgets/outfit_selection_sheet.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        context.read<CalendarProvider>().loadEvents(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDay = DateUtils.dateOnly(provider.selectedDay);
    final isPast = selectedDay.isBefore(today);
    
    final dayEvents = provider.getEventsForDay(provider.selectedDay);

    return Scaffold(
      backgroundColor: const Color(0xffF5F2F3),
      appBar: const CalendarHeader(title: "Outfit Planner"),
      floatingActionButton: isPast ? null : AddEventButton(
        onPressed: provider.isLoading ? null : () {
          OutfitSelectionSheet.show(
            context: context,
            onSelect: (outfit) async {
              final userId = SupabaseService.currentUserId ?? '';
              if (userId.isNotEmpty) {
                await context.read<CalendarProvider>().addOrUpdateOutfit(userId, outfit);
              }
            },
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CalendarGrid(
              focusedDay: provider.focusedDay,
              selectedDay: provider.selectedDay,
              onDaySelected: (selected, focused) {
                context.read<CalendarProvider>().changeSelectedDay(selected);
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: provider.isLoading && provider.events.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: Colors.black))
                  : dayEvents.isEmpty
                      ? const EmptyEventState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: dayEvents.length,
                          itemBuilder: (context, index) {
                            final event = dayEvents[index];
                            if (event.outfit == null) return const SizedBox.shrink();

                            return EventCard(
                              outfit: event.outfit!,
                              onTap: isPast ? null : () {
                                OutfitSelectionSheet.show(
                                  context: context,
                                  onSelect: (newOutfit) async {
                                    final userId = SupabaseService.currentUserId ?? '';
                                    if (userId.isNotEmpty) {
                                      await context.read<CalendarProvider>().addOrUpdateOutfit(userId, newOutfit);
                                    }
                                  },
                                );
                              },
                              onDelete: isPast ? null : () async {
                                await provider.removeEvent(event.id);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
