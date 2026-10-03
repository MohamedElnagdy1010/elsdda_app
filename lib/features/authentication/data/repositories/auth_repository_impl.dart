import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) {
    return remoteDataSource.register(
      name: name,
      email: email,
      phone: phone,
      address: address,
      password: password,
    );
  }

  @override
  Future<UserEntity> login({required String email, required String password}) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}
