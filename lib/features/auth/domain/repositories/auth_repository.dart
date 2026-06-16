import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> updatePassword({required String newPassword});

  Future<void> deleteAccount();
}
