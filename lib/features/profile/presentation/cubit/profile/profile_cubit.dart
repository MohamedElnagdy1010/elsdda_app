import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_profile_use_case.dart';
import '../../../domain/use_cases/update_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    try {
      final user = await getProfileUseCase();

      emit(ProfileLoaded(user));
    } catch (_) {
      emit(const ProfileFailure('تعذر تحميل بيانات الحساب'));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final currentState = state;

    if (currentState is! ProfileLoaded &&
        currentState is! ProfileUpdateSuccess) {
      return;
    }

    final currentUser = currentState is ProfileLoaded
        ? currentState.user
        : (currentState as ProfileUpdateSuccess).user;

    if (name.trim().isEmpty) {
      emit(
        ProfileUpdateFailure(user: currentUser, message: 'من فضلك أدخل الاسم'),
      );
      return;
    }

    if (phone.trim().isEmpty) {
      emit(
        ProfileUpdateFailure(
          user: currentUser,
          message: 'من فضلك أدخل رقم الهاتف',
        ),
      );
      return;
    }

    emit(ProfileUpdating(currentUser));

    try {
      final updatedUser = await updateProfileUseCase(
        name: name,
        phone: phone,
        address: address,
      );

      emit(ProfileUpdateSuccess(updatedUser));

      // نرجع للحالة الطبيعية بعد نجاح التحديث.
      emit(ProfileLoaded(updatedUser));
    } catch (_) {
      emit(
        ProfileUpdateFailure(
          user: currentUser,
          message: 'تعذر تحديث بيانات الحساب',
        ),
      );

      emit(ProfileLoaded(currentUser));
    }
  }
}
