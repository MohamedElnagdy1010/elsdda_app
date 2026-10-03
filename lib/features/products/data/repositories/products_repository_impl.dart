import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../data_sources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() {
    return remoteDataSource.getCategories();
  }

  @override
  Future<List<ProductEntity>> getProducts() {
    return remoteDataSource.getProducts();
  }

  @override
  Future<List<ProductEntity>> getPopularProducts() {
    return remoteDataSource.getPopularProducts();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) {
    return remoteDataSource.getProductsByCategory(categoryId);
  }

  @override
  Future<List<ProductEntity>> getFeaturedProducts() {
    return remoteDataSource.getFeaturedProducts();
  }

  @override
  Future<List<ProductEntity>> getLatestProducts() {
    return remoteDataSource.getLatestProducts();
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) {
    return remoteDataSource.searchProducts(query);
  }
}
