import 'dart:math';
import 'package:get_storage/get_storage.dart';
import 'package:pos/utils/val.dart';

/// Secure verification code service
/// Generates cryptographically secure codes with expiry and rate limiting
class VerificationService {
  static const int _codeLength = 6;
  static const int _maxAttempts = 5;
  static const Duration _codeExpiry = Duration(minutes: 10);

  /// Generate a cryptographically secure verification code
  static String generateSecureCode() {
    final random = Random.secure();
    final code = List<int>.generate(
      _codeLength,
      (_) => random.nextInt(10),
    ).join();
    return code;
  }

  /// Store verification code with metadata
  static Future<void> storeCode({
    required String code,
    required String email,
  }) async {
    final storage = GetStorage();
    final data = {
      'code': code,
      'email': email,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'attempts': 0,
    };
    await storage.write(DBVal.resetPassword, data);
  }

  /// Verify a code and return result
  static Future<VerificationResult> verifyCode({
    required String inputCode,
    required String email,
  }) async {
    final storage = GetStorage();
    final data = storage.read(DBVal.resetPassword);

    if (data == null) {
      return VerificationResult(
        success: false,
        message: 'No verification code found. Please request a new code.',
      );
    }

    // Check if email matches
    if (data['email'] != email) {
      return VerificationResult(
        success: false,
        message: 'Invalid verification request.',
      );
    }

    // Check expiry
    final timestamp = data['timestamp'] as int;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(createdAt) > _codeExpiry) {
      await storage.remove(DBVal.resetPassword);
      return VerificationResult(
        success: false,
        message: 'Code expired. Please request a new one.',
      );
    }

    // Check attempts
    final attempts = data['attempts'] as int;
    if (attempts >= _maxAttempts) {
      await storage.remove(DBVal.resetPassword);
      return VerificationResult(
        success: false,
        message: 'Too many failed attempts. Please request a new code.',
      );
    }

    // Verify code
    if (data['code'] == inputCode) {
      await storage.remove(DBVal.resetPassword); // One-time use
      return VerificationResult(
        success: true,
        message: 'Code verified successfully',
      );
    }

    // Increment attempts on failure
    data['attempts'] = attempts + 1;
    await storage.write(DBVal.resetPassword, data);

    return VerificationResult(
      success: false,
      message: 'Invalid code. ${_maxAttempts - attempts - 1} attempts remaining.',
    );
  }

  /// Clear stored verification code
  static Future<void> clearCode() async {
    final storage = GetStorage();
    await storage.remove(DBVal.resetPassword);
  }

  /// Check if a code exists and is still valid
  static Future<bool> hasValidCode() async {
    final storage = GetStorage();
    final data = storage.read(DBVal.resetPassword);

    if (data == null) return false;

    final timestamp = data['timestamp'] as int;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(createdAt) <= _codeExpiry;
  }
}

/// Result of verification attempt
class VerificationResult {
  final bool success;
  final String message;

  VerificationResult({
    required this.success,
    required this.message,
  });
}
