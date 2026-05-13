import '../../../core/services/supabase_service.dart';

class AuthService {

  Future<void> register({
    required String email,
    required String password,
  }) async {

    await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {

    await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {

    await SupabaseService.client.auth.signOut();
  }

  bool get isLoggedIn {

    return SupabaseService
            .client
            .auth
            .currentUser !=
        null;
  }
}