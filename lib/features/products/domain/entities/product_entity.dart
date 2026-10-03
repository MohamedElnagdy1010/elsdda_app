import 'package:equatable/equatable.dart';
import 'package:sufra_app/features/products/domain/entities/product_option_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String categoryId;
  final double rating;
  final int reviews;
  final bool isPopular;
  final bool isFeatured;
  final bool isAvailable;
  final DateTime? createdAt;
  final List<ProductOptionEntity> options;
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.rating,
    required this.reviews,
    required this.isPopular,
    required this.isFeatured,
    required this.isAvailable,
    this.createdAt,
    this.options = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    image,
    categoryId,
    rating,
    reviews,
    isPopular,
    isFeatured,
    isAvailable,
    createdAt,
    options,
  ];
}
