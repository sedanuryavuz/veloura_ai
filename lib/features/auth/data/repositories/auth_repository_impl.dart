import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.login(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<User> register({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.register(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userModel = await remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await remoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    await remoteDataSource.updatePassword(newPassword: newPassword);
  }
}
