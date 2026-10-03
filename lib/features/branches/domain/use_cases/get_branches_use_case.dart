import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';
import 'package:sufra_app/features/branches/domain/repositories/branches_repository.dart';

class GetBranchesUseCase {
  final BranchesRepository repository;

  GetBranchesUseCase(this.repository);

  Future<List<BranchEntity>> call() {
    return repository.getBranches();
  }
}
