import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';

abstract class BranchesState {
  const BranchesState();
}

class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

class BranchesLoaded extends BranchesState {
  final List<BranchEntity> branches;

  const BranchesLoaded(this.branches);
}

class BranchesFailure extends BranchesState {
  final String message;

  const BranchesFailure(this.message);
}
