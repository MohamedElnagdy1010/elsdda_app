import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_notifications_as_read_use_case.dart';
import '../../domain/use_cases/mark_notification_as_read_use_case.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase? getNotificationsUseCase;
  final MarkNotificationAsReadUseCase? markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase? markAllNotificationsAsReadUseCase;

  NotificationsCubit({
    this.getNotificationsUseCase,
    this.markNotificationAsReadUseCase,
    this.markAllNotificationsAsReadUseCase,
  }) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    final useCase = getNotificationsUseCase;

    if (useCase == null) {
      emit(
        const NotificationsState(
          status: NotificationsStatus.success,
          notifications: [],
        ),
      );
      return;
    }

    emit(state.copyWith(status: NotificationsStatus.loading, clearError: true));

    try {
      final notifications = await useCase();

      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          errorMessage: 'تعذر تحميل الإشعارات حاليًا.',
        ),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }

      return notification;
    }).toList();

    emit(state.copyWith(notifications: updatedNotifications));

    try {
      await markNotificationAsReadUseCase?.call(notificationId);
    } catch (_) {
      // سيتم تحسين مزامنة الأخطاء عند ربط مصدر البيانات.
    }
  }

  Future<void> markAllAsRead() async {
    final updatedNotifications = state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();

    emit(state.copyWith(notifications: updatedNotifications));

    try {
      await markAllNotificationsAsReadUseCase?.call();
    } catch (_) {
      // سيتم تحسين مزامنة الأخطاء عند ربط مصدر البيانات.
    }
  }
}
