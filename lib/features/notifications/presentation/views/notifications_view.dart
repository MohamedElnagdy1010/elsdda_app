import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_entity.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  static const Color primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..loadNotifications(),
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الإشعارات',
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 19,
            ),
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state.unreadCount == 0) {
                  return const SizedBox.shrink();
                }

                return TextButton(
                  onPressed: () {
                    context.read<NotificationsCubit>().markAllAsRead();
                  },
                  child: const Text(
                    'قراءة الكل',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: const _NotificationsBody(),
      ),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        switch (state.status) {
          case NotificationsStatus.initial:
          case NotificationsStatus.loading:
            return const Center(
              child: CircularProgressIndicator(
                color: NotificationsView.primaryColor,
              ),
            );

          case NotificationsStatus.failure:
            return _EmptyState(
              icon: Icons.error_outline_rounded,
              title: 'تعذر تحميل الإشعارات',
              message: state.errorMessage ?? 'حدث خطأ غير متوقع.',
              buttonText: 'إعادة المحاولة',
              onPressed: () {
                context.read<NotificationsCubit>().loadNotifications();
              },
            );

          case NotificationsStatus.success:
            if (state.notifications.isEmpty) {
              return const _EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'لا توجد إشعارات',
                message:
                    'سنخبرك هنا عند وجود تحديثات على طلباتك أو عروض جديدة.',
              );
            }

            return RefreshIndicator(
              color: NotificationsView.primaryColor,
              onRefresh: () {
                return context.read<NotificationsCubit>().loadNotifications();
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];

                  return _NotificationCard(
                    notification: notification,
                    onTap: () {
                      context.read<NotificationsCubit>().markAsRead(
                        notification.id,
                      );

                      // عند ربط الطلبات لاحقًا:
                      // لو orderId موجود نفتح تفاصيل الطلب.
                    },
                  );
                },
              ),
            );
        }
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = switch (notification.type) {
      NotificationType.order => Icons.receipt_long_rounded,
      NotificationType.offer => Icons.local_offer_outlined,
      NotificationType.general => Icons.notifications_none_rounded,
    };

    return Material(
      color: notification.isRead ? Colors.white : const Color(0xffFFF6F6),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? const Color(0xffEEEEEE)
                  : const Color(0xffB60F1A).withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xffB60F1A).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: const Color(0xffB60F1A), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 7),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xffB60F1A),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.body,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _formatDate(notification.createdAt),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} - $hour:$minute';
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xffF1F1F1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: Colors.grey),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NotificationsView.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
