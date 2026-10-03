import 'package:equatable/equatable.dart';

import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/domain/entities/product_option_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final ProductOptionEntity? selectedOption;

  const CartItemEntity({
    required this.product,
    required this.quantity,
    this.selectedOption,
  });

  double get unitPrice {
    return product.price + (selectedOption?.additionalPrice ?? 0);
  }

  double get totalPrice {
    return unitPrice * quantity;
  }

  String get cartKey {
    final optionName = selectedOption?.name.trim() ?? '';

    return '${product.id}::$optionName';
  }

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
    ProductOptionEntity? selectedOption,
    bool clearSelectedOption = false,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedOption: clearSelectedOption
          ? null
          : selectedOption ?? this.selectedOption,
    );
  }

  @override
  List<Object?> get props => [product, quantity, selectedOption];
}
