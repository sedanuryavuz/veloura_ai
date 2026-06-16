import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _localeCode = 'en';

  String get localeCode => _localeCode;
  Locale get locale => Locale(_localeCode);

  LanguageProvider() {
    _loadLocale();
  }

  void _loadLocale() {
    _localeCode = PreferencesService.instance.getString('selected_locale', defaultValue: 'en');
  }

  Future<void> setLocale(String code) async {
    if (_localeCode == code) return;
    _localeCode = code;
    await PreferencesService.instance.setString('selected_locale', code);
    notifyListeners();
  }
}

