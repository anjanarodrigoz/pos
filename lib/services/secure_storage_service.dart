import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Platform-specific secure storage implementation
/// Uses GetStorage on desktop (macOS, Windows, Linux) to avoid Keychain/signing issues
/// Uses FlutterSecureStorage on mobile (iOS, Android) for native secure storage
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  late final GetStorage _desktopStorage;
  late final FlutterSecureStorage _mobileStorage;
  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;

  bool _initialized = false;

  /// Initialize storage based on platform
  Future<void> initialize() async {
    if (_initialized) return;

    if (_isDesktop()) {
      // Use GetStorage for desktop platforms
      await GetStorage.init('secure_storage');
      _desktopStorage = GetStorage('secure_storage');

      // Initialize encryption for desktop storage
      String? keyString = _desktopStorage.read('_encryption_key');
      if (keyString == null) {
        final key = encrypt.Key.fromSecureRandom(32);
        _iv = encrypt.IV.fromSecureRandom(16);
        _desktopStorage.write('_encryption_key', key.base64);
        _desktopStorage.write('_encryption_iv', _iv.base64);
        _encrypter = encrypt.Encrypter(encrypt.AES(key));
      } else {
        final key = encrypt.Key.fromBase64(keyString);
        final ivString = _desktopStorage.read('_encryption_iv');
        _iv = encrypt.IV.fromBase64(ivString);
        _encrypter = encrypt.Encrypter(encrypt.AES(key));
      }
    } else {
      // Use FlutterSecureStorage for mobile platforms
      _mobileStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      );
    }

    _initialized = true;
  }

  /// Check if running on desktop platform
  bool _isDesktop() {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  /// Write a value
  Future<void> write({required String key, required String value}) async {
    if (!_initialized) await initialize();

    if (_isDesktop()) {
      // Encrypt value for desktop storage
      final encrypted = _encrypter.encrypt(value, iv: _iv);
      _desktopStorage.write(key, encrypted.base64);
    } else {
      await _mobileStorage.write(key: key, value: value);
    }
  }

  /// Read a value
  Future<String?> read({required String key}) async {
    if (!_initialized) await initialize();

    if (_isDesktop()) {
      final encryptedValue = _desktopStorage.read(key);
      if (encryptedValue == null) return null;

      try {
        final encrypted = encrypt.Encrypted.fromBase64(encryptedValue);
        return _encrypter.decrypt(encrypted, iv: _iv);
      } catch (e) {
        return null;
      }
    } else {
      return await _mobileStorage.read(key: key);
    }
  }

  /// Delete a value
  Future<void> delete({required String key}) async {
    if (!_initialized) await initialize();

    if (_isDesktop()) {
      _desktopStorage.remove(key);
    } else {
      await _mobileStorage.delete(key: key);
    }
  }

  /// Check if a key exists
  Future<bool> containsKey({required String key}) async {
    if (!_initialized) await initialize();

    if (_isDesktop()) {
      return _desktopStorage.hasData(key);
    } else {
      final value = await _mobileStorage.read(key: key);
      return value != null;
    }
  }

  /// Delete all values
  Future<void> deleteAll() async {
    if (!_initialized) await initialize();

    if (_isDesktop()) {
      _desktopStorage.erase();
    } else {
      await _mobileStorage.deleteAll();
    }
  }
}
