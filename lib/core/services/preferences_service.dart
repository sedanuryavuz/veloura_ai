import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PreferencesService {
  PreferencesService._privateConstructor();
  static final PreferencesService instance = PreferencesService._privateConstructor();

  static const String _fileName = 'app_preferences.json';
  Map<String, dynamic> _prefs = {};
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          _prefs = jsonDecode(content) as Map<String, dynamic>;
        }
      }
      _initialized = true;
    } catch (e) {
      _initialized = true;
    }
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs[key] as bool? ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    _prefs[key] = value;
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(_prefs));
    } catch (_) {
      // Ignored
    }
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs[key] as String? ?? defaultValue;
  }

  Future<void> setString(String key, String value) async {
    _prefs[key] = value;
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(_prefs));
    } catch (_) {
      // Ignored
    }
  }
}
