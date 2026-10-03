import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetFeaturedProductsUseCase {
  final ProductsRepository repository;

  GetFeaturedProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() {
    return repository.getFeaturedProducts();
  }
}
