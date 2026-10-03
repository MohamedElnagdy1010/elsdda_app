import 'package:sufra_app/features/branches/data/data_sources/branches_remote_data_source.dart';
import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';
import 'package:sufra_app/features/branches/domain/repositories/branches_repository.dart';

class BranchesRepositoryImpl implements BranchesRepository {
  final BranchesRemoteDataSource remoteDataSource;

  BranchesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BranchEntity>> getBranches() {
    return remoteDataSource.getBranches();
  }
}
