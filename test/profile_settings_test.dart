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
import 'package:veloura_ai/features/auth/domain/usecases/delete_account.dart';
import 'package:veloura_ai/features/auth/presentation/provider/auth_provider.dart';
import 'package:veloura_ai/core/providers/language_provider.dart';
import 'package:veloura_ai/features/profile/presentation/pages/profile_page.dart';
import 'package:veloura_ai/features/profile/presentation/pages/change_password_page.dart';
import 'package:veloura_ai/core/services/preferences_service.dart';
import 'package:veloura_ai/core/l10n/app_localizations.dart';

class FakeAuthRepository implements AuthRepository {
  bool throwNetworkError = false;
  bool throwSupabaseError = false;
  bool isDeleteCalled = false;
  bool isUpdateCalled = false;

  @override
  Future<void> deleteAccount() async {
    isDeleteCalled = true;
    if (throwSupabaseError) {
      throw Exception('administrative');
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    isUpdateCalled = true;
    if (throwNetworkError) {
      throw Exception('network-request-failed');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {}
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
  late LanguageProvider languageProvider;

  setUp(() {
    PreferencesService.instance.setString('selected_locale', 'en');
    fakeAuthRepository = FakeAuthRepository();
    authProvider = AuthProvider(
      loginUsecase: Login(fakeAuthRepository),
      registerUsecase: Register(fakeAuthRepository),
      logoutUsecase: Logout(fakeAuthRepository),
      getCurrentUserUsecase: GetCurrentUser(fakeAuthRepository),
      sendPasswordResetEmailUsecase: SendPasswordResetEmail(fakeAuthRepository),
      updatePasswordUsecase: UpdatePassword(fakeAuthRepository),
      deleteAccountUsecase: DeleteAccount(fakeAuthRepository),
    );
    languageProvider = LanguageProvider();
  });

  group('LanguageProvider Tests', () {
    test('Updates and persists locale correctly', () async {
      expect(languageProvider.localeCode, 'en');
      expect(languageProvider.locale, const Locale('en'));

      await languageProvider.setLocale('tr');
      expect(languageProvider.localeCode, 'tr');
      expect(languageProvider.locale, const Locale('tr'));
      expect(PreferencesService.instance.getString('selected_locale'), 'tr');
    });
  });

  group('ProfilePage & ChangePasswordPage Widget Tests', () {
    Widget buildTestWidget({Widget? home}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: languageProvider.locale,
          home: home ?? const ProfilePage(),
        ),
      );
    }

    testWidgets('ProfilePage displays email, membership and tiles', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Should show user email or default text
      expect(find.text("fashionista@veloura.ai"), findsOneWidget);
      expect(find.text("FREE PLAN"), findsOneWidget);

      // Section titles should be visible in English
      expect(find.text("ACCOUNT"), findsOneWidget);
      expect(find.text("APP"), findsOneWidget);
    });

    testWidgets('Tapping delete account triggers confirmation dialog', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Delete Account settings tile
      final deleteTile = find.text("Delete Account");
      expect(deleteTile, findsOneWidget);
      await tester.tap(deleteTile);
      await tester.pumpAndSettle();

      // Verify Delete confirmation dialog opens
      expect(find.text("Are you sure you want to permanently delete your account? This action is irreversible."), findsOneWidget);

      // Tap Delete button
      await tester.tap(find.text("Delete"));
      await tester.pumpAndSettle();

      // Verify repository method called
      expect(fakeAuthRepository.isDeleteCalled, true);
    });

    testWidgets('ChangePasswordPage validates password length', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(home: const ChangePasswordPage()),
      );

      // Enter short password
      await tester.enterText(find.byType(TextFormField).first, '123');
      await tester.tap(find.text('UPDATE PASSWORD'));
      await tester.pumpAndSettle();

      expect(find.text("Password must be at least 6 characters"), findsOneWidget);
    });
  });
}
