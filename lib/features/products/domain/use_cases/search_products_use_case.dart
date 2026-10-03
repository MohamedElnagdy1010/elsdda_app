import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/domain/repositories/products_repository.dart';

class SearchProductsUseCase {
  final ProductsRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<ProductEntity>> call(String query) {
    return repository.searchProducts(query);
  }
}
