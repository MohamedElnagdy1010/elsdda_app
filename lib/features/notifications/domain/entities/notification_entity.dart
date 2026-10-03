import 'package:equatable/equatable.dart';

enum NotificationType { order, offer, general }

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  /// تستخدم لاحقًا لفتح طلب معين من الإشعار.
  final String? orderId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.orderId,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? orderId,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      orderId: orderId ?? this.orderId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    type,
    createdAt,
    isRead,
    orderId,
  ];
}
