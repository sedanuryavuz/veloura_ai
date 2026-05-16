import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_current_user.dart';

class AuthProvider extends ChangeNotifier {
  final Login loginUsecase;
  final Register registerUsecase;
  final Logout logoutUsecase;
  final GetCurrentUser getCurrentUserUsecase;

  AuthProvider({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
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

  String _formatError(String error) {
    if (error.contains('invalid-credential') || error.contains('Invalid login credentials')) {
      return 'Invalid email or password.';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already registered.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
