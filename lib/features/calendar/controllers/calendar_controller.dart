import 'package:flutter/material.dart';

import '../../outfit/models/outfit_model.dart';
import '../models/calendar_outfit_model.dart';

class CalendarController extends ChangeNotifier {

  DateTime focusedDay = DateTime.now();

  DateTime selectedDay = DateTime.now();

  final List<CalendarOutfitModel> plannedOutfits = [];

  void changeSelectedDay(DateTime day) {
    selectedDay = day;
    focusedDay = day;
    notifyListeners();
  }

void addOrUpdateOutfit(
  OutfitModel outfit,
) {

  final existingIndex =
      plannedOutfits.indexWhere(
    (e) =>
        e.date.year == selectedDay.year &&
        e.date.month == selectedDay.month &&
        e.date.day == selectedDay.day,
  );

  if (existingIndex != -1) {

    plannedOutfits[existingIndex] =
        CalendarOutfitModel(
      date: selectedDay,
      outfit: outfit,
    );

  } else {

    plannedOutfits.add(
      CalendarOutfitModel(
        date: selectedDay,
        outfit: outfit,
      ),
    );
  }

  notifyListeners();
}

  OutfitModel? getOutfitForDay(DateTime day) {

    try {
      return plannedOutfits.firstWhere(
        (e) =>
            e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day,
      ).outfit;
    } catch (_) {
      return null;
    }
  }
  void removePlannedOutfit(DateTime day) {

  plannedOutfits.removeWhere(
    (e) =>
        e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day,
  );

  notifyListeners();
}
}