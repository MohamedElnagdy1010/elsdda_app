import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String phone,
    required String address,
  }) {
    return repository.updateProfile(name: name, phone: phone, address: address);
  }
}
