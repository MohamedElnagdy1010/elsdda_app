import '../entities/category_entity.dart';
import '../repositories/products_repository.dart';

class GetCategoriesUseCase {
  final ProductsRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
