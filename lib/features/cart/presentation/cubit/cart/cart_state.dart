import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  int get totalQuantity {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  double get subtotal {
    return items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [items];
}
