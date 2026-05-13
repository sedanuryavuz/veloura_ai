import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {

  final AuthService _authService =
      AuthService();

  bool isLoading = false;

  Future<bool> login({
    required String email,
    required String password,
  }) async {

    try {

      isLoading = true;
      notifyListeners();

      await _authService.login(
        email: email,
        password: password,
      );

      return true;

    } catch (e) {

      return false;

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {

    try {

      isLoading = true;
      notifyListeners();

      await _authService.register(
        email: email,
        password: password,
      );

      return true;

    } catch (e) {

      return false;

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }
}