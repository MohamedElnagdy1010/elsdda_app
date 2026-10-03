import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/logout_use_case.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await logoutUseCase();

      emit(LogoutSuccess());
    } catch (_) {
      emit(const LogoutFailure('حدث خطأ أثناء تسجيل الخروج'));
    }
  }
}
