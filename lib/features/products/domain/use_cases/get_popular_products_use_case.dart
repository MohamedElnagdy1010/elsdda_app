import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetPopularProductsUseCase {
  final ProductsRepository repository;

  GetPopularProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() {
    return repository.getPopularProducts();
  }
}
