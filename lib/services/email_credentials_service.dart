import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for SMTP email credentials
/// Prevents credentials from being stored in plain text or backups
class EmailCredentialsService {
  static const _storage = FlutterSecureStorage();
  static const String _smtpPasswordKey = 'smtp_password_encrypted';
  static const String _smtpUsernameKey = 'smtp_username';
  static const String _smtpServerKey = 'smtp_server';
  static const String _smtpPortKey = 'smtp_port';

  /// Save SMTP password securely
  static Future<void> saveSmtpPassword(String password) async {
    await _storage.write(key: _smtpPasswordKey, value: password);
  }

  /// Get SMTP password
  static Future<String?> getSmtpPassword() async {
    return await _storage.read(key: _smtpPasswordKey);
  }

  /// Save SMTP username
  static Future<void> saveSmtpUsername(String username) async {
    await _storage.write(key: _smtpUsernameKey, value: username);
  }

  /// Get SMTP username
  static Future<String?> getSmtpUsername() async {
    return await _storage.read(key: _smtpUsernameKey);
  }

  /// Save SMTP server
  static Future<void> saveSmtpServer(String server) async {
    await _storage.write(key: _smtpServerKey, value: server);
  }

  /// Get SMTP server
  static Future<String?> getSmtpServer() async {
    return await _storage.read(key: _smtpServerKey);
  }

  /// Save SMTP port
  static Future<void> saveSmtpPort(int port) async {
    await _storage.write(key: _smtpPortKey, value: port.toString());
  }

  /// Get SMTP port
  static Future<int> getSmtpPort() async {
    final portString = await _storage.read(key: _smtpPortKey);
    return int.tryParse(portString ?? '465') ?? 465;
  }

  /// Save all SMTP credentials at once
  static Future<void> saveSmtpCredentials({
    required String username,
    required String password,
    required String server,
    int port = 465,
  }) async {
    await saveSmtpUsername(username);
    await saveSmtpPassword(password);
    await saveSmtpServer(server);
    await saveSmtpPort(port);
  }

  /// Check if SMTP credentials are configured
  static Future<bool> hasCredentials() async {
    final password = await getSmtpPassword();
    final username = await getSmtpUsername();
    return password != null && username != null;
  }

  /// Delete all SMTP credentials
  static Future<void> deleteSmtpCredentials() async {
    await _storage.delete(key: _smtpPasswordKey);
    await _storage.delete(key: _smtpUsernameKey);
    await _storage.delete(key: _smtpServerKey);
    await _storage.delete(key: _smtpPortKey);
  }

  /// Migrate from Store model to secure storage
  static Future<void> migrateFromStore({
    required String email,
    required String password,
    required String smtpServer,
  }) async {
    await saveSmtpCredentials(
      username: email,
      password: password,
      server: smtpServer,
    );
  }
}
