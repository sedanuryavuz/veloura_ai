import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/widgets/v_delete_dialog.dart';
import '../provider/calendar_provider.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_header.dart';
import '../widgets/event_card.dart';
import '../widgets/empty_event_state.dart';
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
      appBar: const CalendarHeader(title: "Outfit Planner"),
      floatingActionButton: isPast ? null : Padding(
        padding: const EdgeInsets.only(bottom: 96), // Fixed: Higher margin from bottom nav
        child: FloatingActionButton(
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
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
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
                      ? const Center(child: CircularProgressIndicator())
                      : dayEvents.isEmpty
                          ? const EmptyEventState()
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 120), // Fixed: Clear space for bottom nav
                              itemCount: dayEvents.length,
                              itemBuilder: (context, index) {
                                final event = dayEvents[index];
                                if (event.outfit == null) return const SizedBox.shrink();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: EventCard(
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
                                    onDelete: isPast ? null : () {
                                      VDeleteDialog.show(
                                        context,
                                        title: "Delete Plan?",
                                        content: "Do you want to remove this outfit from your calendar?",
                                        onDelete: () => provider.removeEvent(event.id),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
