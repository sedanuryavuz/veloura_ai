import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) async {
    return await repository.register(
      email: email,
      password: password,
    );
  }
}
