import '../repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  const MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
