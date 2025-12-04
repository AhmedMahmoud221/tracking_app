import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'user_token';

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
}
