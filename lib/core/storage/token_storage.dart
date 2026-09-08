import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Penyimpanan token Sanctum — Keychain (iOS) / Keystore (Android) via
/// flutter_secure_storage, BUKAN SharedPreferences biasa (plaintext).
abstract final class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }
}
