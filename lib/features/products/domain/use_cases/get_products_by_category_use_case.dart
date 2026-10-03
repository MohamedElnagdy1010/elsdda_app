import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductsRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<ProductEntity>> call(String categoryId) {
    return repository.getProductsByCategory(categoryId);
  }
}
