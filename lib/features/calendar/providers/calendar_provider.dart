import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../outfit/models/outfit_model.dart';
import '../models/calendar_outfit_model.dart';
import '../repositories/calendar_repository.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarRepository _repository;

  CalendarProvider(this._repository);

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  List<CalendarOutfitModel> _plannedOutfits = [];
  List<CalendarOutfitModel> get plannedOutfits => List.unmodifiable(_plannedOutfits);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void changeSelectedDay(DateTime day) {
    selectedDay = day;
    focusedDay = day;
    notifyListeners();
  }

  Future<void> loadOutfits(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plannedOutfits = await _repository.getOutfits(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdateOutfit(String userId, OutfitModel outfit) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final existingIndex = _plannedOutfits.indexWhere(
        (e) =>
            e.date.year == selectedDay.year &&
            e.date.month == selectedDay.month &&
            e.date.day == selectedDay.day &&
            e.outfitId == outfit.id, // Support multiple outfits per day if needed
      );

      if (existingIndex != -1) {
        // Just delete and re-add or skip if it's the exact same
        // But for simplicity of calendar: we just add a new calendar record
        // The user selected an outfit for this day. 
        // If they "update" it, we might want to drop the old one. 
        // Actually, the UI allows deleting a specific planned outfit via `removePlannedOutfit`.
        // Let's assume we want to support multiple outfits per day, so we just add it.
        // Wait, the previous controller just updated it if it existed.
        // Let's check: The old code did indexWhere on date only. Which meant ONE outfit per day!
      }
      
      // Let's find if there's any outfit for this day to replace it, to match old logic
      final replaceIndex = _plannedOutfits.indexWhere(
        (e) =>
            e.date.year == selectedDay.year &&
            e.date.month == selectedDay.month &&
            e.date.day == selectedDay.day,
      );

      final newModel = CalendarOutfitModel(
        id:  const Uuid().v4(),
        userId: userId,
        outfitId: outfit.id,
        date: selectedDay,
        outfit: outfit,
        createdAt: DateTime.now(),
      );

      if (replaceIndex != -1) {
        await _repository.deleteOutfit(_plannedOutfits[replaceIndex].id);
        _plannedOutfits.removeAt(replaceIndex);
      }

      final savedModel = await _repository.addOutfit(newModel);
      _plannedOutfits.add(savedModel);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removePlannedOutfit(String calendarOutfitId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _repository.deleteOutfit(calendarOutfitId);
      _plannedOutfits.removeWhere((e) => e.id == calendarOutfitId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  OutfitModel? getOutfitForDay(DateTime day) {
    try {
      return _plannedOutfits.firstWhere(
        (e) =>
            e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day,
      ).outfit;
    } catch (_) {
      return null;
    }
  }
}
