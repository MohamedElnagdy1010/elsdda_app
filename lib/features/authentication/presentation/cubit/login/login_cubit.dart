import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/login_use_case.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      emit(const LoginFailure('من فضلك أدخل البريد الإلكتروني وكلمة المرور'));
      return;
    }

    emit(LoginLoading());

    try {
      final user = await loginUseCase(email: email, password: password);

      emit(LoginSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_getFirebaseMessage(e.code)));
    } catch (e) {
      emit(const LoginFailure('حدث خطأ أثناء تسجيل الدخول'));
    }
  }

  String _getFirebaseMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';

      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';

      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';

      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';

      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

      case 'too-many-requests':
        return 'محاولات كثيرة، حاول مرة أخرى لاحقًا';

      case 'network-request-failed':
        return 'تحقق من اتصالك بالإنترنت';

      default:
        return 'تعذر تسجيل الدخول، حاول مرة أخرى';
    }
  }
}
