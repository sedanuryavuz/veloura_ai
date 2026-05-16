import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class GenerateAISchedule {
  final CalendarRepository repository;

  GenerateAISchedule(this.repository);

  Future<List<CalendarEvent>> call(String userId, String prompt) async {
    return await repository.generateAISchedule(userId, prompt);
  }
}
