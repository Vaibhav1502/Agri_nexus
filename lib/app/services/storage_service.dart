import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  final _tokenKey = 'auth_token';
   final _userKey = 'user_data'; // 👈 Add a key for user data

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // 👇 --- ADD THESE NEW METHODS --- 👇

  /// Save user data (as a JSON string)
  Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Get user data (as a JSON string)
  Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  /// Clear user data
  Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }
}
