import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // keys
  static const _tokenKey = 'user_token';
  static const _themeKey = 'app_token';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Read token
  static Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // theme
  static Future<void> saveTheme(bool isDark) async {
    await _storage.write(key: _themeKey, value: isDark ? 'dark' : 'light');
  }

  static Future<bool> readTheme() async {
    final value = await _storage.read(key: _themeKey);
    return value == 'dark';
  }

  // language
  static const _langKey = 'selected_language';

  static Future<void> writeLanguage(String lang) async {
    await _storage.write(key: _langKey, value: lang);
  }

  static Future<String?> readLanguage() async {
    return await _storage.read(key: _langKey);
  }
}
