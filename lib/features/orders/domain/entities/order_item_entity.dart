import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String name;
  final String image;

  /// السعر النهائي للوحدة بعد إضافة سعر الاختيار.
  final double price;

  final int quantity;

  /// اسم الاختيار مثل: الحجم الكبير.
  final String? selectedOption;

  /// فرق السعر الخاص بالاختيار.
  final double optionAdditionalPrice;

  const OrderItemEntity({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.selectedOption,
    this.optionAdditionalPrice = 0,
  });

  double get totalPrice => price * quantity;

  bool get hasSelectedOption {
    return selectedOption != null && selectedOption!.trim().isNotEmpty;
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    image,
    price,
    quantity,
    selectedOption,
    optionAdditionalPrice,
  ];
}
