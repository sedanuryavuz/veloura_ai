import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/features/auth/domain/entities/user.dart';
import 'package:veloura_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:veloura_ai/features/auth/domain/usecases/login.dart';
import 'package:veloura_ai/features/auth/domain/usecases/register.dart';
import 'package:veloura_ai/features/auth/domain/usecases/logout.dart';
import 'package:veloura_ai/features/auth/domain/usecases/get_current_user.dart';
import 'package:veloura_ai/features/auth/domain/usecases/send_password_reset_email.dart';
import 'package:veloura_ai/features/auth/domain/usecases/update_password.dart';
import 'package:veloura_ai/features/auth/presentation/provider/auth_provider.dart';
import 'package:veloura_ai/features/auth/presentation/pages/forgot_password_page.dart';

class FakeAuthRepository implements AuthRepository {
  bool throwNetworkError = false;
  bool throwSupabaseError = false;
  bool isResetCalled = false;
  String? resetEmail;
  bool isUpdatePasswordCalled = false;
  String? updatedPassword;

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    isResetCalled = true;
    resetEmail = email;
    if (throwNetworkError) {
      throw Exception('network-request-failed');
    }
    if (throwSupabaseError) {
      throw Exception('Email rate limit exceeded');
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    isUpdatePasswordCalled = true;
    updatedPassword = newPassword;
    if (throwNetworkError) {
      throw Exception('network-request-failed');
    }
    if (throwSupabaseError) {
      throw Exception('Password update failed');
    }
  }

  @override
  Future<User> login({required String email, required String password}) async => throw UnimplementedError();
  @override
  Future<User> register({required String email, required String password}) async => throw UnimplementedError();
  @override
  Future<void> logout() async {}
  @override
  Future<User?> getCurrentUser() async => null;
}

void main() {
  late FakeAuthRepository fakeAuthRepository;
  late AuthProvider authProvider;

  setUp(() {
    fakeAuthRepository = FakeAuthRepository();
    authProvider = AuthProvider(
      loginUsecase: Login(fakeAuthRepository),
      registerUsecase: Register(fakeAuthRepository),
      logoutUsecase: Logout(fakeAuthRepository),
      getCurrentUserUsecase: GetCurrentUser(fakeAuthRepository),
      sendPasswordResetEmailUsecase: SendPasswordResetEmail(fakeAuthRepository),
      updatePasswordUsecase: UpdatePassword(fakeAuthRepository),
    );
  });

  group('AuthProvider forgot password tests', () {
    test('Successful reset email triggers repository call and sets loading', () async {
      expect(authProvider.isLoading, false);
      expect(authProvider.error, null);

      final success = await authProvider.sendPasswordResetEmail('test@example.com');

      expect(success, true);
      expect(fakeAuthRepository.isResetCalled, true);
      expect(fakeAuthRepository.resetEmail, 'test@example.com');
      expect(authProvider.isLoading, false);
      expect(authProvider.error, null);
    });

    test('Network failure is caught and formatted properly', () async {
      fakeAuthRepository.throwNetworkError = true;

      final success = await authProvider.sendPasswordResetEmail('test@example.com');

      expect(success, false);
      expect(authProvider.error, 'Network error. Please check your connection.');
    });

    test('Supabase error (rate limit) is caught and formatted properly', () async {
      fakeAuthRepository.throwSupabaseError = true;

      final success = await authProvider.sendPasswordResetEmail('test@example.com');

      expect(success, false);
      expect(authProvider.error, 'Rate limit exceeded. Please try again later.');
    });
  });

  group('ForgotPasswordPage Widget/Validation tests', () {
    Widget buildTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: const ForgotPasswordPage(),
        ),
      );
    }

    testWidgets('Empty email validation error', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Send Reset Link without entering anything
      await tester.tap(find.text('SEND RESET LINK'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Invalid email validation error', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      await tester.tap(find.text('SEND RESET LINK'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Successful reset shows Check Your Inbox dialog', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('SEND RESET LINK'));
      await tester.pumpAndSettle();

      expect(find.text('Check Your Inbox'), findsOneWidget);
      expect(find.text('If an account exists for this email, a password reset link has been sent. Please check your inbox.'), findsOneWidget);
    });
  });
}
