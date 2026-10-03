import 'package:equatable/equatable.dart';

import '../../../domain/entities/order_entity.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrderCreatedSuccess extends OrdersState {
  final OrderEntity order;

  const OrderCreatedSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersFailure extends OrdersState {
  final String message;

  const OrdersFailure(this.message);

  @override
  List<Object?> get props => [message];
}
