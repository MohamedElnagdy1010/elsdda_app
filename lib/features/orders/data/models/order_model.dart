import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.total,
    required super.address,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items,
      subtotal: entity.subtotal,
      deliveryFee: entity.deliveryFee,
      total: entity.total,
      address: entity.address,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    final rawItems = map['items'] as List<dynamic>? ?? [];

    final paymentMethod = map['paymentMethod'] as String? ?? 'cash';

    return OrderModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      items: rawItems
          .map(
            (item) =>
                OrderItemModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (map['total'] as num?)?.toDouble() ?? 0,
      address: map['address'] as String? ?? '',
      paymentMethod: paymentMethod,
      paymentStatus:
          map['paymentStatus'] as String? ??
          _legacyPaymentStatus(paymentMethod),
      status: map['status'] as String? ?? 'pending',
      createdAt: _dateTimeFromFirestore(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items
          .map((item) => OrderItemModel.fromEntity(item).toMap())
          .toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'address': address,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static String _legacyPaymentStatus(String paymentMethod) {
    if (paymentMethod == 'online') {
      return 'pending';
    }

    return 'unpaid';
  }

  static DateTime _dateTimeFromFirestore(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}
