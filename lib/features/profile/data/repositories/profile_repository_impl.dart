import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<UserEntity> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) {
    return remoteDataSource.updateProfile(
      name: name,
      phone: phone,
      address: address,
    );
  }
}
