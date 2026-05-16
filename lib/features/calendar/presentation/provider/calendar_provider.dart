import 'package:flutter/material.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/usecases/get_calendar_events.dart';
import '../../domain/usecases/add_calendar_event.dart';
import '../../domain/usecases/delete_calendar_event.dart';
import '../../domain/usecases/update_calendar_event.dart';
import '../../../outfit/domain/entities/outfit.dart';
import 'package:uuid/uuid.dart';

class CalendarProvider extends ChangeNotifier {
  final GetCalendarEvents _getEvents;
  final AddCalendarEvent _addEvent;
  final DeleteCalendarEvent _deleteEvent;
  // Removed unused _updateEvent

  CalendarProvider({
    required GetCalendarEvents getEvents,
    required AddCalendarEvent addEvent,
    required DeleteCalendarEvent deleteEvent,
  })  : _getEvents = getEvents,
        _addEvent = addEvent,
        _deleteEvent = deleteEvent;

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  List<CalendarEvent> _events = [];
  List<CalendarEvent> get events => List.unmodifiable(_events);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void changeSelectedDay(DateTime day) {
    selectedDay = day;
    focusedDay = day;
    notifyListeners();
  }

  Future<void> loadEvents(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _getEvents(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdateOutfit(String userId, Outfit outfit) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Find if there's any event for this day to replace it
      final replaceIndex = _events.indexWhere(
        (e) => _isSameDay(e.date, selectedDay),
      );

      final newEvent = CalendarEvent(
        id: const Uuid().v4(),
        userId: userId,
        outfitId: outfit.id,
        date: selectedDay,
        outfit: outfit,
        createdAt: DateTime.now(),
      );

      if (replaceIndex != -1) {
        await _deleteEvent(_events[replaceIndex].id);
        _events.removeAt(replaceIndex);
      }

      final savedEvent = await _addEvent(newEvent);
      _events.add(savedEvent);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeEvent(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _deleteEvent(id);
      _events.removeWhere((e) => e.id == id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events.where((e) => _isSameDay(e.date, day)).toList();
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
