import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sufra_app/features/cart/presentation/cubit/cart/cart_state.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/domain/entities/product_option_entity.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());
  static const int maxQuantityPerItem = 20;
  final List<CartItemEntity> _items = [];

  void addProduct(
    ProductEntity product, {
    int quantity = 1,
    ProductOptionEntity? selectedOption,
  }) {
    if (quantity <= 0) return;

    final safeQuantity = quantity.clamp(1, maxQuantityPerItem);

    final newItem = CartItemEntity(
      product: product,
      quantity: safeQuantity,
      selectedOption: selectedOption,
    );

    final existingIndex = _items.indexWhere(
      (item) => item.cartKey == newItem.cartKey,
    );

    if (existingIndex != -1) {
      final existingItem = _items[existingIndex];

      final updatedQuantity = (existingItem.quantity + safeQuantity).clamp(
        1,
        maxQuantityPerItem,
      );

      _items[existingIndex] = existingItem.copyWith(quantity: updatedQuantity);
    } else {
      _items.add(newItem);
    }

    _emitCart();
  }

  void increaseQuantity(String cartKey) {
    final index = _items.indexWhere((item) => item.cartKey == cartKey);

    if (index == -1) return;

    final item = _items[index];

    if (item.quantity >= maxQuantityPerItem) {
      return;
    }

    _items[index] = item.copyWith(quantity: item.quantity + 1);

    _emitCart();
  }

  void decreaseQuantity(String cartKey) {
    final index = _items.indexWhere((item) => item.cartKey == cartKey);

    if (index == -1) return;

    final item = _items[index];

    if (item.quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = item.copyWith(quantity: item.quantity - 1);
    }

    _emitCart();
  }

  void removeProduct(String cartKey) {
    _items.removeWhere((item) => item.cartKey == cartKey);

    _emitCart();
  }

  void clearCart() {
    _items.clear();
    _emitCart();
  }

  void _emitCart() {
    emit(CartState(items: List.unmodifiable(_items)));
  }
}
