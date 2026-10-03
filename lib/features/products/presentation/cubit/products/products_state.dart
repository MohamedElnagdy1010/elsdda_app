import 'package:equatable/equatable.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> popularProducts;
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> latestProducts;

  const ProductsLoaded({
    required this.categories,
    required this.popularProducts,
    required this.featuredProducts,
    required this.latestProducts,
  });

  @override
  List<Object?> get props => [
    categories,
    popularProducts,
    featuredProducts,
    latestProducts,
  ];
}

final class ProductsFailure extends ProductsState {
  final String message;

  const ProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class CategoryProductsLoading extends ProductsState {}

final class CategoryProductsLoaded extends ProductsState {
  final List<ProductEntity> products;

  const CategoryProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

final class CategoryProductsFailure extends ProductsState {
  final String message;

  const CategoryProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
