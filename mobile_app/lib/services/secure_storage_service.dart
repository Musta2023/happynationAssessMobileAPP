import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A wrapper service for [FlutterSecureStorage] to abstract secure data storage.
///
/// FIXED: Aligned method names (read, write, deleteAll) to match the expectations
/// of the existing AuthService, resolving a major conflict.
class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  /// Writes a value to a given key in secure storage.
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from a given key in secure storage.
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a value from a given key in secure storage.
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Deletes all data from secure storage.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}