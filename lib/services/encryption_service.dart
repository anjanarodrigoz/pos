import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encryption service for protecting Personally Identifiable Information (PII)
/// Uses AES-256 encryption with secure key storage
class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const String _encryptionKeyKey = 'encryption_key';
  static const String _ivKey = 'encryption_iv';

  static encrypt.Encrypter? _encrypter;
  static encrypt.IV? _iv;
  static bool _initialized = false;

  /// Initialize encryption service
  /// Must be called before any encryption/decryption operations
  static Future<void> initialize() async {
    if (_initialized) return;

    String? keyString = await _storage.read(key: _encryptionKeyKey);
    String? ivString = await _storage.read(key: _ivKey);

    if (keyString == null || ivString == null) {
      // Generate new encryption keys
      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);

      await _storage.write(key: _encryptionKeyKey, value: key.base64);
      await _storage.write(key: _ivKey, value: iv.base64);

      _encrypter = encrypt.Encrypter(encrypt.AES(key));
      _iv = iv;
    } else {
      // Load existing keys
      final key = encrypt.Key.fromBase64(keyString);
      _iv = encrypt.IV.fromBase64(ivString);
      _encrypter = encrypt.Encrypter(encrypt.AES(key));
    }

    _initialized = true;
  }

  /// Encrypt a string
  /// Returns plaintext if encryption is not available (graceful degradation)
  static String encryptString(String plainText) {
    if (!_initialized || _encrypter == null || _iv == null) {
      // Gracefully degrade to plaintext if encryption not available
      return plainText;
    }
    if (plainText.isEmpty) return '';
    try {
      return _encrypter!.encrypt(plainText, iv: _iv!).base64;
    } catch (e) {
      // Return plaintext if encryption fails
      return plainText;
    }
  }

  /// Decrypt a string
  /// Returns the input string if decryption is not available (graceful degradation)
  static String decryptString(String encrypted) {
    if (!_initialized || _encrypter == null || _iv == null) {
      // Gracefully degrade - return as-is if encryption not available
      return encrypted;
    }
    if (encrypted.isEmpty) return '';

    try {
      return _encrypter!.decrypt64(encrypted, iv: _iv!);
    } catch (e) {
      // If decryption fails, it might be plain text from migration
      return encrypted;
    }
  }

  /// Check if a string is encrypted
  static bool isEncrypted(String text) {
    if (text.isEmpty) return false;
    try {
      // Try to decode as base64
      encrypt.Encrypted.fromBase64(text);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Encrypt data if not already encrypted
  static String encryptIfNeeded(String text) {
    if (isEncrypted(text)) {
      return text;
    }
    return encryptString(text);
  }

  /// Check if encryption is available
  static bool get isAvailable => _initialized && _encrypter != null && _iv != null;

  /// Reset encryption keys (WARNING: All encrypted data will be lost)
  static Future<void> resetKeys() async {
    await _storage.delete(key: _encryptionKeyKey);
    await _storage.delete(key: _ivKey);
    _initialized = false;
    _encrypter = null;
    _iv = null;
  }
}
