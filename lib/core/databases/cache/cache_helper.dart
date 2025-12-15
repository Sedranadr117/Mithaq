import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageHelper {
  static final SecureStorageHelper instance = SecureStorageHelper._internal();
  factory SecureStorageHelper() => instance;

  SecureStorageHelper._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save data (String, bool, int, double, map, list)
  Future<void> saveData({required String key, required dynamic value}) async {
    if (value is String) {
      await _storage.write(key: key, value: value);
    } else {
      // تحول كل الأنواع الأخرى إلى String (JSON)
      final jsonString = jsonEncode(value);
      await _storage.write(key: key, value: jsonString);
    }
  }

  /// Get data (automatically decodes JSON if needed)
  Future<dynamic> getData(String key) async {
    final storedValue = await _storage.read(key: key);
    if (storedValue == null) return null;

    // نحاول نفك JSON، وإذا فشل يعني هي String عادية
    try {
      return jsonDecode(storedValue);
    } catch (e) {
      return storedValue; // قيمة نصية بسيطة
    }
  }

  /// Get String only
  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  /// Remove Key
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all data
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    final all = await _storage.readAll();
    return all.containsKey(key);
  }

  /// Get saved user email
  Future<String?> getSavedUserEmail() async {
    return await getString('USER_EMAIL');
  }

  /// Get saved user first name
  Future<String?> getSavedUserFirstName() async {
    return await getString('USER_FIRST_NAME');
  }

  /// Get saved user last name
  Future<String?> getSavedUserLastName() async {
    return await getString('USER_LAST_NAME');
  }

  /// Get saved auth token
  Future<String?> getSavedAuthToken(String key) async {
    return await getString(key);
  }

  /// Check if user is logged in (has token)
  Future<bool> isUserLoggedIn() async {
    final token = await getSavedAuthToken('AUTH_TOKEN');
    return token != null && token.isNotEmpty;
  }

  /// Clear all user data (logout)
  Future<void> clearUserData() async {
    await remove('AUTH_TOKEN');
    await remove('USER_EMAIL');
    await remove('USER_FIRST_NAME');
    await remove('USER_LAST_NAME');
    await remove('USER_IS_ACTIVE');
  }
}
