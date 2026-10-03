import 'package:equatable/equatable.dart';

import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;

  final double subtotal;
  final double deliveryFee;
  final double total;

  final String address;
  final String paymentMethod;
  final String paymentStatus;
  final String status;

  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.address,
    required this.paymentMethod,
    this.paymentStatus = 'unpaid',
    required this.status,
    required this.createdAt,
  });

  bool get isPaid => paymentStatus == 'paid';

  int get totalItems {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    subtotal,
    deliveryFee,
    total,
    address,
    paymentMethod,
    paymentStatus,
    status,
    createdAt,
  ];
}
