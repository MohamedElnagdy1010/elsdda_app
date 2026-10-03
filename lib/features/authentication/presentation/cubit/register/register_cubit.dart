import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/register_use_case.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        phone.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      emit(const RegisterFailure('من فضلك أكمل جميع البيانات'));
      return;
    }

    if (password != confirmPassword) {
      emit(const RegisterFailure('كلمتا المرور غير متطابقتين'));
      return;
    }

    emit(RegisterLoading());

    try {
      await registerUseCase(
        name: name,
        email: email,
        phone: phone,
        address: address,
        password: password,
      );

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailure(_getFirebaseMessage(e.code)));
    } catch (e) {
      emit(const RegisterFailure('حدث خطأ أثناء إنشاء الحساب'));
    }
  }

  String _getFirebaseMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';

      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';

      case 'weak-password':
        return 'كلمة المرور ضعيفة';

      case 'network-request-failed':
        return 'تحقق من اتصالك بالإنترنت';

      default:
        return 'تعذر إنشاء الحساب، حاول مرة أخرى';
    }
  }
}
