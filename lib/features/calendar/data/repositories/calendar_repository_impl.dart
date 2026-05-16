import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_remote_data_source.dart';
import '../datasources/calendar_local_data_source.dart';
import '../datasources/event_ai_data_source.dart';
import '../datasources/notification_data_source.dart';
import '../models/calendar_event_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;
  final CalendarLocalDataSource localDataSource;
  final EventAIDataSource aiDataSource;
  final NotificationDataSource notificationDataSource;

  CalendarRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.aiDataSource,
    required this.notificationDataSource,
  });

  @override
  Future<List<CalendarEvent>> getEvents(String userId) async {
    try {
      final remoteEvents = await remoteDataSource.getEvents(userId);
      await localDataSource.cacheEvents(remoteEvents);
      return remoteEvents.map((e) => e.toEntity()).toList();
    } catch (e) {
      // Fallback to local
      final localEvents = await localDataSource.getCachedEvents();
      return localEvents.map((e) => e.toEntity()).toList();
    }
  }

  @override
  Future<CalendarEvent> addEvent(CalendarEvent event) async {
    final model = CalendarEventModel.fromEntity(event);
    final savedModel = await remoteDataSource.addEvent(model);
    return savedModel.toEntity();
  }

  @override
  Future<void> updateEvent(CalendarEvent event) async {
    final model = CalendarEventModel.fromEntity(event);
    await remoteDataSource.updateEvent(model);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await remoteDataSource.deleteEvent(id);
  }

  @override
  Future<List<CalendarEvent>> getEventsByDate(String userId, DateTime date) async {
    final allEvents = await getEvents(userId);
    return allEvents.where((e) => 
      e.date.year == date.year && 
      e.date.month == date.month && 
      e.date.day == date.day
    ).toList();
  }

  @override
  Future<List<CalendarEvent>> generateAISchedule(String userId, String prompt) async {
    final aiEvents = await aiDataSource.generateSchedule(userId, prompt);
    return aiEvents.map((e) => e.toEntity()).toList();
  }
}
