import '../../../authentication/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile();

  Future<UserEntity> updateProfile({
    required String name,
    required String phone,
    required String address,
  });
}
