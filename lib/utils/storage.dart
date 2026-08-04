import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = "auth_token";
  static const _roleKey = "user_role";
  static const _currentTripKey = "current_trip_id";

  // 🔹 Token methods
  static Future<void> writeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // 🔹 Role methods
  static Future<void> writeRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  static Future<String?> readRole() async {
    return await _storage.read(key: _roleKey);
  }

  static Future<void> deleteRole() async {
    await _storage.delete(key: _roleKey);
  }

  // 🔹 Current Trip ID methods
  static Future<void> writeCurrentTripId(String tripId) async {
    await _storage.write(key: _currentTripKey, value: tripId);
  }

  static Future<String?> readCurrentTripId() async {
    return await _storage.read(key: _currentTripKey);
  }

  static Future<void> deleteCurrentTripId() async {
    await _storage.delete(key: _currentTripKey);
  }
}
