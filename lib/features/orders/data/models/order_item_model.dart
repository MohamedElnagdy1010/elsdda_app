import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.name,
    required super.image,
    required super.price,
    required super.quantity,
    super.selectedOption,
    super.optionAdditionalPrice = 0,
  });

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      productId: entity.productId,
      name: entity.name,
      image: entity.image,
      price: entity.price,
      quantity: entity.quantity,
      selectedOption: entity.selectedOption,
      optionAdditionalPrice: entity.optionAdditionalPrice,
    );
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      selectedOption: map['selectedOption']?.toString(),
      optionAdditionalPrice:
          (map['optionAdditionalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'selectedOption': selectedOption,
      'optionAdditionalPrice': optionAdditionalPrice,
    };
  }
}
