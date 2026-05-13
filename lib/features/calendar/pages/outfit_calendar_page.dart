import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/calendar_controller.dart';

import '../widgets/calendar_widget.dart';
import '../widgets/empty_planner.dart';
import '../widgets/outfit_selection_sheet.dart';
import '../widgets/planned_outfit_card.dart';

class OutfitCalendarPage extends StatelessWidget {
  const OutfitCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CalendarController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F2F3),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,

        child: const Icon(Icons.add, color: Colors.white),

        onPressed: () {
          OutfitSelectionSheet.show(
            context: context,

            onSelect: (outfit) {
              controller.addOrUpdateOutfit(outfit);
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
              focusedDay: controller.focusedDay,

              selectedDay: controller.selectedDay,

              onDaySelected: (selected, focused) {
                controller.changeSelectedDay(selected);
              },
            ),

            const SizedBox(height: 24),

            Expanded(
              child: controller.plannedOutfits.isEmpty
                  ? const EmptyPlanner()
                  : ListView.builder(
                      itemCount: controller.plannedOutfits.length,

                      itemBuilder: (context, index) {
                        final item = controller.plannedOutfits[index];

                        return PlannedOutfitCard(
                          outfit: item.outfit,

                          onTap: () {
                            OutfitSelectionSheet.show(
                              context: context,

                              onSelect: (newOutfit) {
                                controller.changeSelectedDay(item.date);

                                controller.addOrUpdateOutfit(newOutfit);
                              },
                            );
                          },

                          onDelete: () {
                            controller.removePlannedOutfit(item.date);
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
