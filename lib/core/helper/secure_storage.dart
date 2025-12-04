import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// save token for always login
class SecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'Bearer';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
