import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_option_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.image,
    required super.categoryId,
    required super.isPopular,
    required super.isAvailable,
    super.createdAt,
    required super.rating,
    required super.reviews,
    required super.isFeatured,
    super.options = const [],
  });

  factory ProductModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final createdAtValue = map['createdAt'];

    return ProductModel(
      id: id,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image']?.toString() ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (map['reviews'] as num?)?.toInt() ?? 0,
      isPopular: map['isPopular'] as bool? ?? false,
      isFeatured: map['isFeatured'] as bool? ?? false,
      isAvailable: map['isAvailable'] as bool? ?? true,
      createdAt: createdAtValue is Timestamp ? createdAtValue.toDate() : null,
      options: _parseOptions(map['options']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'categoryId': categoryId,
      'isPopular': isPopular,
      'isAvailable': isAvailable,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'rating': rating,
      'reviews': reviews,
      'isFeatured': isFeatured,
      'options': options
          .map(
            (option) => {
              'name': option.name,
              'additionalPrice': option.additionalPrice,
            },
          )
          .toList(),
    };
  }

  static List<ProductOptionEntity> _parseOptions(dynamic data) {
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map(
          (option) => ProductOptionEntity(
            name: option['name']?.toString() ?? '',
            additionalPrice:
                (option['additionalPrice'] as num?)?.toDouble() ?? 0.0,
          ),
        )
        .where((option) => option.name.trim().isNotEmpty)
        .toList();
  }
}
