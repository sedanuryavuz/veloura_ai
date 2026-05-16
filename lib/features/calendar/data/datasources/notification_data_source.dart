abstract class NotificationDataSource {
  Future<void> scheduleNotification(String title, String body, DateTime scheduledTime);
  Future<void> cancelNotification(int id);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  @override
  Future<void> scheduleNotification(String title, String body, DateTime scheduledTime) async {
    // TODO: Implement notification scheduling logic
  }

  @override
  Future<void> cancelNotification(int id) async {
    // TODO: Implement notification cancellation logic
  }
}
