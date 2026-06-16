import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> updatePassword({required String newPassword});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login failed: User is null');
    }

    return UserModel(
      id: response.user!.id,
      email: response.user!.email!,
      name: response.user!.userMetadata?['name'],
      avatarUrl: response.user!.userMetadata?['avatar_url'],
    );
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Registration failed: User is null');
    }

    return UserModel(
      id: response.user!.id,
      email: response.user!.email!,
      name: response.user!.userMetadata?['name'],
      avatarUrl: response.user!.userMetadata?['avatar_url'],
    );
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email!,
      name: user.userMetadata?['name'],
      avatarUrl: user.userMetadata?['avatar_url'],
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'veloura-ai://login-callback',
    );
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    await client.auth.updateUser(
      supabase.UserAttributes(password: newPassword),
    );
  }
}
