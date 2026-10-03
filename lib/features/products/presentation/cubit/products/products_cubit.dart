import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_latest_products_use_case.dart';

import '../../../domain/use_cases/get_categories_use_case.dart';
import '../../../domain/use_cases/get_featured_products_use_case.dart';
import '../../../domain/use_cases/get_popular_products_use_case.dart';
import '../../../domain/use_cases/get_products_by_category_use_case.dart';
import '../../../domain/use_cases/get_products_use_case.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetPopularProductsUseCase getPopularProductsUseCase;
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetLatestProductsUseCase getLatestProductsUseCase;
  ProductsCubit({
    required this.getCategoriesUseCase,
    required this.getPopularProductsUseCase,
    required this.getFeaturedProductsUseCase,
    required this.getProductsByCategoryUseCase,
    required this.getProductsUseCase,
    required this.getLatestProductsUseCase,
  }) : super(ProductsInitial());

  Future<void> loadHomeData() async {
    emit(ProductsLoading());

    try {
      final categories = await getCategoriesUseCase();
      final popularProducts = await getPopularProductsUseCase();
      final featuredProducts = await getFeaturedProductsUseCase();
      final latestProducts = await getLatestProductsUseCase();

      emit(
        ProductsLoaded(
          categories: categories,
          popularProducts: popularProducts,
          featuredProducts: featuredProducts,
          latestProducts: latestProducts,
        ),
      );
    } catch (e) {
      emit(ProductsFailure(e.toString()));
    }
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    emit(CategoryProductsLoading());

    try {
      final products = await getProductsByCategoryUseCase(categoryId);

      emit(CategoryProductsLoaded(products: products));
    } catch (_) {
      emit(
        const CategoryProductsFailure('تعذر تحميل منتجات القسم، حاول مرة أخرى'),
      );
    }
  }

  Future<void> loadAllProducts() async {
    emit(CategoryProductsLoading());

    try {
      final products = await getProductsUseCase();

      emit(CategoryProductsLoaded(products: products));
    } catch (_) {
      emit(const CategoryProductsFailure('تعذر تحميل المنتجات، حاول مرة أخرى'));
    }
  }
}
