import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageHelper {
  static final SecureStorageHelper instance = SecureStorageHelper._internal();
  factory SecureStorageHelper() => instance;

  SecureStorageHelper._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save data (String, bool, int, double, map, list)
  Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
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
}
