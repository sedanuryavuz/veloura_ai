import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/send_password_reset_email.dart';
import '../../domain/usecases/update_password.dart';

class AuthProvider extends ChangeNotifier {
  final Login loginUsecase;
  final Register registerUsecase;
  final Logout logoutUsecase;
  final GetCurrentUser getCurrentUserUsecase;
  final SendPasswordResetEmail sendPasswordResetEmailUsecase;
  final UpdatePassword updatePasswordUsecase;

  AuthProvider({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.sendPasswordResetEmailUsecase,
    required this.updatePasswordUsecase,
  });

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await getCurrentUserUsecase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await loginUsecase(email: email, password: password);
      return true;
    } catch (e) {
      _error = _formatError(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await registerUsecase(email: email, password: password);
      return true;
    } catch (e) {
      _error = _formatError(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await logoutUsecase();
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await sendPasswordResetEmailUsecase(email: email);
      return true;
    } catch (e) {
      _error = _formatError(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await updatePasswordUsecase(newPassword: newPassword);
      return true;
    } catch (e) {
      _error = _formatError(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatError(String error) {
    if (error.contains('invalid-credential') || error.contains('Invalid login credentials')) {
      return 'Invalid email or password.';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already registered.';
    } else if (error.contains('network') || error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    } else if (error.contains('rate') || error.contains('limit exceeded')) {
      return 'Rate limit exceeded. Please try again later.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
