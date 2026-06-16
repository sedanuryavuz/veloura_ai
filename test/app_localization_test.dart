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
import 'package:veloura_ai/core/services/preferences_service.dart';
import 'package:veloura_ai/core/l10n/app_localizations.dart';
import 'package:veloura_ai/features/auth/presentation/pages/login_page.dart';
import 'package:veloura_ai/features/profile/presentation/pages/profile_page.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> deleteAccount() async {}
  @override
  Future<void> updatePassword({required String newPassword}) async {}
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

  setUp(() {
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
  });

  group('Localization System Tests', () {
    Widget buildTestWidget(LanguageProvider languageProvider, {Widget? home}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: languageProvider.locale,
          home: home ?? const LoginPage(),
        ),
      );
    }

    test('English Startup and Defaults', () {
      PreferencesService.instance.setString('selected_locale', 'en');
      final lp = LanguageProvider();
      expect(lp.localeCode, 'en');
      expect(lp.locale, const Locale('en'));
    });

    test('Turkish Startup', () {
      PreferencesService.instance.setString('selected_locale', 'tr');
      final lp = LanguageProvider();
      expect(lp.localeCode, 'tr');
      expect(lp.locale, const Locale('tr'));
    });

    test('Language switching and App restart persistence', () async {
      PreferencesService.instance.setString('selected_locale', 'en');
      final lp = LanguageProvider();
      expect(lp.localeCode, 'en');

      await lp.setLocale('tr');
      expect(lp.localeCode, 'tr');
      expect(PreferencesService.instance.getString('selected_locale'), 'tr');

      final newLp = LanguageProvider();
      expect(newLp.localeCode, 'tr');
    });

    testWidgets('Login Page Form Validation Localization - English vs Turkish', (WidgetTester tester) async {
      PreferencesService.instance.setString('selected_locale', 'en');
      final lp = LanguageProvider();

      await tester.pumpWidget(buildTestWidget(lp));
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

      // Switch to Turkish
      await lp.setLocale('tr');
      await tester.pumpAndSettle();

      // Trigger validation in Turkish
      await tester.tap(find.text('GİRİŞ YAP'));
      await tester.pumpAndSettle();

      expect(find.text('Lütfen e-postanızı girin'), findsOneWidget);
      expect(find.text('Lütfen şifrenizi girin'), findsOneWidget);
    });

    testWidgets('Dialog localization', (WidgetTester tester) async {
      PreferencesService.instance.setString('selected_locale', 'tr');
      final lp = LanguageProvider();

      await tester.pumpWidget(buildTestWidget(lp, home: const ProfilePage()));
      
      // Tap delete account tile in Turkish
      final deleteTile = find.text("Hesabı Sil");
      expect(deleteTile, findsOneWidget);
      await tester.tap(deleteTile);
      await tester.pumpAndSettle();

      expect(find.text("Hesabı Sil"), findsWidgets); // Title and tile
      expect(find.text("Hesabınızı kalıcı olarak silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."), findsOneWidget);
    });
  });
}
