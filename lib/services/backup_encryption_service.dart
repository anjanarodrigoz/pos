import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pos/services/secure_storage_service.dart';

/// Encryption service for database backups
/// Ensures backup files are encrypted and cannot be read without credentials
class BackupEncryptionService {
  static final _storage = SecureStorageService();
  static const String _backupKeyKey = 'backup_encryption_key';

  /// Initialize backup encryption with user password
  /// Should be called after user logs in or sets password
  static Future<void> initializeBackupKey(String userPassword) async {
    // Derive a 32-character key from user password
    final key = encrypt.Key.fromUtf8(
      userPassword.padRight(32, '0').substring(0, 32),
    );
    await _storage.write(key: _backupKeyKey, value: key.base64);
  }

  /// Encrypt backup data
  static Future<List<int>> encryptBackup(List<int> data) async {
    final keyBase64 = await _storage.read(key: _backupKeyKey);
    if (keyBase64 == null) {
      throw Exception('Backup encryption key not initialized');
    }

    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encryptBytes(data, iv: iv);

    // Prepend IV to encrypted data (IV is not secret, just needs to be unique)
    return [...iv.bytes, ...encrypted.bytes];
  }

  /// Decrypt backup data
  static Future<List<int>> decryptBackup(List<int> encryptedData) async {
    final keyBase64 = await _storage.read(key: _backupKeyKey);
    if (keyBase64 == null) {
      throw Exception('Backup encryption key not initialized');
    }

    if (encryptedData.length < 16) {
      throw Exception('Invalid encrypted backup file');
    }

    final key = encrypt.Key.fromBase64(keyBase64);

    // Extract IV (first 16 bytes)
    final iv = encrypt.IV(Uint8List.fromList(encryptedData.take(16).toList()));

    // Extract encrypted data (rest of bytes)
    final encrypted = encrypt.Encrypted(
      Uint8List.fromList(encryptedData.skip(16).toList()),
    );

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    try {
      return encrypter.decryptBytes(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Failed to decrypt backup. Wrong password or corrupted file.');
    }
  }

  /// Check if backup key is initialized
  static Future<bool> hasBackupKey() async {
    final key = await _storage.read(key: _backupKeyKey);
    return key != null;
  }

  /// Delete backup encryption key
  static Future<void> deleteBackupKey() async {
    await _storage.delete(key: _backupKeyKey);
  }
}
