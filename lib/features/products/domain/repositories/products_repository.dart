import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> getProducts();

  Future<List<ProductEntity>> getPopularProducts();

  Future<List<ProductEntity>> getFeaturedProducts();

  Future<List<ProductEntity>> getProductsByCategory(String categoryId);

  Future<List<ProductEntity>> getLatestProducts();
  Future<List<ProductEntity>> searchProducts(String query);
}
