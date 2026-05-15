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

  // Optimization: Map for O(1) lookup
  final Map<String, OutfitModel> _outfitMap = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _dateKey(DateTime date) => "${date.year}-${date.month}-${date.day}";

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
      _outfitMap.clear();
      for (var p in _plannedOutfits) {
        _outfitMap[_dateKey(p.date)] = p.outfit;
      }
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
      final key = _dateKey(selectedDay);
      
      // Find if there's any outfit for this day to replace it
      final replaceIndex = _plannedOutfits.indexWhere(
        (e) => _dateKey(e.date) == key,
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
      _outfitMap[key] = savedModel.outfit;
      
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
      final index = _plannedOutfits.indexWhere((e) => e.id == calendarOutfitId);
      if (index != -1) {
        final item = _plannedOutfits[index];
        await _repository.deleteOutfit(calendarOutfitId);
        _outfitMap.remove(_dateKey(item.date));
        _plannedOutfits.removeAt(index);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  OutfitModel? getOutfitForDay(DateTime day) {
    return _outfitMap[_dateKey(day)];
  }
}
