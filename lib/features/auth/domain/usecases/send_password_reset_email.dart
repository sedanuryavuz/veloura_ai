import '../repositories/auth_repository.dart';

class SendPasswordResetEmail {
  final AuthRepository repository;

  SendPasswordResetEmail(this.repository);

  Future<void> call({required String email}) async {
    await repository.sendPasswordResetEmail(email: email);
  }
}
