import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetLatestProductsUseCase {
  final ProductsRepository repository;

  GetLatestProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() {
    return repository.getLatestProducts();
  }
}
