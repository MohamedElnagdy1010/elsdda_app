import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/features/branches/domain/use_cases/get_branches_use_case.dart';
import 'package:sufra_app/features/branches/presentation/cubit/branches/branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final GetBranchesUseCase getBranchesUseCase;

  BranchesCubit({required this.getBranchesUseCase})
    : super(const BranchesInitial());

  Future<void> getBranches() async {
    emit(const BranchesLoading());

    try {
      final branches = await getBranchesUseCase();

      emit(BranchesLoaded(branches));
    } catch (_) {
      emit(const BranchesFailure('حدث خطأ أثناء تحميل الفروع'));
    }
  }
}
