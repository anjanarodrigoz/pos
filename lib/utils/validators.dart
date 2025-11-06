/// Validation utilities for email, password, and other inputs
class Validators {
  // Common weak passwords to reject
  static const List<String> _commonPasswords = [
    '123456',
    'password',
    '12345678',
    'qwerty',
    '123456789',
    '12345',
    '1234',
    '111111',
    '1234567',
    'dragon',
    '123123',
    'baseball',
    'iloveyou',
    'trustno1',
    '1234567890',
    'sunshine',
    'princess',
    'admin',
    'welcome',
    'login',
  ];

  /// Validate email address using RFC 5322 regex
  static bool validateEmail(String email) {
    if (email.isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Validate password strength
  /// Returns PasswordStrength with validation details
  static PasswordStrength validatePassword(String password) {
    if (password.length < 8) {
      return PasswordStrength(
        isValid: false,
        message: 'Password must be at least 8 characters',
        strength: 0,
      );
    }

    // Check for common passwords
    if (isCommonPassword(password)) {
      return PasswordStrength(
        isValid: false,
        message: 'Password is too common. Please choose a stronger password.',
        strength: 0,
      );
    }

    int strength = 0;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecialChars) strength++;
    if (password.length >= 12) strength++;

    // Require at least 3 different character types
    if (strength < 3) {
      return PasswordStrength(
        isValid: false,
        message: 'Password must contain uppercase, lowercase, and numbers',
        strength: strength,
      );
    }

    // Determine strength level
    String message;
    if (strength == 5) {
      message = 'Very strong password';
    } else if (strength == 4) {
      message = 'Strong password';
    } else {
      message = 'Good password';
    }

    return PasswordStrength(
      isValid: true,
      message: message,
      strength: strength,
    );
  }

  /// Check if password is in the common passwords list
  static bool isCommonPassword(String password) {
    return _commonPasswords.contains(password.toLowerCase());
  }

  /// Validate phone number (basic validation)
  static bool validatePhone(String phone) {
    if (phone.isEmpty) return false;

    // Remove common formatting characters
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    // Check if it's all digits and has reasonable length
    final phoneRegex = RegExp(r'^\d{7,15}$');
    return phoneRegex.hasMatch(cleanPhone);
  }

  /// Validate if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate numeric string
  static bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return double.tryParse(value) != null;
  }

  /// Validate positive number
  static bool isPositiveNumber(String value) {
    if (!isNumeric(value)) return false;
    final number = double.parse(value);
    return number > 0;
  }
}

/// Password strength information
class PasswordStrength {
  final bool isValid;
  final String message;
  final int strength; // 0-5 scale

  PasswordStrength({
    required this.isValid,
    required this.message,
    required this.strength,
  });

  /// Get strength as percentage (0-100)
  int get percentage => (strength * 20).clamp(0, 100);

  /// Get strength level name
  String get levelName {
    if (strength == 0) return 'Very Weak';
    if (strength == 1) return 'Weak';
    if (strength == 2) return 'Fair';
    if (strength == 3) return 'Good';
    if (strength == 4) return 'Strong';
    return 'Very Strong';
  }
}
