import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../outfit/domain/entities/outfit.dart';

import 'package:veloura_ai/core/services/supabase_service.dart';

import '../providers/calendar_provider.dart';

import '../widgets/calendar_widget.dart';
import '../widgets/empty_planner.dart';
import '../widgets/outfit_selection_sheet.dart';
import '../widgets/planned_outfit_card.dart';

class OutfitCalendarPage extends StatefulWidget {
  const OutfitCalendarPage({super.key});

  @override
  State<OutfitCalendarPage> createState() => _OutfitCalendarPageState();
}

class _OutfitCalendarPageState extends State<OutfitCalendarPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final userId = SupabaseService.currentUserId ?? '';
        if (userId.isNotEmpty) {
          context.read<CalendarProvider>().loadOutfits(userId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(
      provider.selectedDay.year, 
      provider.selectedDay.month, 
      provider.selectedDay.day
    );
    final isPast = selectedDate.isBefore(today);
    
    final dayOutfits = provider.plannedOutfits.where((e) =>
        e.date.year == provider.selectedDay.year &&
        e.date.month == provider.selectedDay.month &&
        e.date.day == provider.selectedDay.day).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF5F2F3),

      floatingActionButton: isPast ? null : FloatingActionButton(
        backgroundColor: Colors.black,

        child: const Icon(Icons.add, color: Colors.white),

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

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text("Outfit Planner"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CalendarWidget(
              focusedDay: provider.focusedDay,

              selectedDay: provider.selectedDay,

              onDaySelected: (selected, focused) {
                context.read<CalendarProvider>().changeSelectedDay(selected);
              },
            ),

            const SizedBox(height: 24),

            if (provider.isLoading && provider.plannedOutfits.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
              child: dayOutfits.isEmpty
                  ? const EmptyPlanner()
                  : ListView.builder(
                      itemCount: dayOutfits.length,

                      itemBuilder: (context, index) {
                        final item = dayOutfits[index];

                        return PlannedOutfitCard(
                          outfit: item.outfit,

                          onTap: isPast ? null : () {
                            OutfitSelectionSheet.show(
                              context: context,

                              onSelect: (newOutfit) async {
                                context.read<CalendarProvider>().changeSelectedDay(item.date);
                                final userId = SupabaseService.currentUserId ?? '';
                                if (userId.isNotEmpty) {
                                  await context.read<CalendarProvider>().addOrUpdateOutfit(userId, newOutfit);
                                }
                              },
                            );
                          },

                          onDelete: isPast ? null : () async {
                            await context.read<CalendarProvider>().removePlannedOutfit(item.id);
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
