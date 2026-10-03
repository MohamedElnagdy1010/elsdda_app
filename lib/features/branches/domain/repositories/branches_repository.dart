import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';

abstract class BranchesRepository {
  Future<List<BranchEntity>> getBranches();
}
