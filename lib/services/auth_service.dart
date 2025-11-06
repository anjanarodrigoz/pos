import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure authentication service with password hashing
/// Uses SHA-256 with salt for password security
class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _passwordKey = 'hashed_password';
  static const String _saltKey = 'password_salt';

  /// Generate a cryptographically secure salt
  static String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// Hash password with salt using SHA-256
  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Set a new password (for registration or password reset)
  /// Validates password strength before setting
  static Future<void> setPassword(String password) async {
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    final salt = _generateSalt();
    final hashedPassword = _hashPassword(password, salt);

    await _storage.write(key: _passwordKey, value: hashedPassword);
    await _storage.write(key: _saltKey, value: salt);
  }

  /// Verify a password against the stored hash
  static Future<bool> verifyPassword(String password) async {
    final storedHash = await _storage.read(key: _passwordKey);
    final salt = await _storage.read(key: _saltKey);

    if (storedHash == null || salt == null) {
      // No password set yet
      return false;
    }

    final inputHash = _hashPassword(password, salt);
    return inputHash == storedHash;
  }

  /// Check if a password has been set
  static Future<bool> hasPassword() async {
    final storedHash = await _storage.read(key: _passwordKey);
    return storedHash != null;
  }

  /// Delete stored password (use with caution)
  static Future<void> deletePassword() async {
    await _storage.delete(key: _passwordKey);
    await _storage.delete(key: _saltKey);
  }

  /// Migrate from old GetStorage plain text password
  static Future<void> migrateFromPlainText(String plainTextPassword) async {
    if (plainTextPassword.isNotEmpty) {
      await setPassword(plainTextPassword);
    }
  }
}
