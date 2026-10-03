import '../repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  const MarkAllNotificationsAsReadUseCase(this.repository);

  Future<void> call() {
    return repository.markAllAsRead();
  }
}
