import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/calendar_event_model.dart';

abstract class EventAIDataSource {
  Future<List<CalendarEventModel>> generateSchedule(String userId, String prompt);
}

class EventAIDataSourceImpl implements EventAIDataSource {
  EventAIDataSourceImpl();

  @override
  Future<List<CalendarEventModel>> generateSchedule(String userId, String prompt) async {
    // TODO: Implement AI schedule generation logic
    // For now returning empty list as it's a new feature structure
    return [];
  }
}
