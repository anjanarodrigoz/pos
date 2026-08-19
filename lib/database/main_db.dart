import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:pos/database/pos_database.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/progressing_dot.dart';

/// Backup and restore controller using Drift database
class MainDB extends GetxController {
  final POSDatabase _database = Get.find<POSDatabase>();
  RxList<Widget> content = <Widget>[].obs;

  @override
  onInit() {
    super.onInit();
    content.clear();
  }

  /// Restore database from a backup file
  Future<void> readDBFile(BuildContext context) async {
    content.clear();

    // Pick backup file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db', 'sqlite', 'sqlite3'],
      dialogTitle: 'Select Backup File',
    );

    if (result == null || result.files.isEmpty) {
      content.clear();
      AlertMessage.snakMessage('File selection cancelled', context);
      return;
    }

    try {
      final filePath = result.files.single.path;
      if (filePath == null) {
        AlertMessage.snakMessage('Invalid file path', context);
        return;
      }

      content.add(ProgressingDots(text: 'Restoring database...'));

      // Close current database connection
      await _database.close();

      // Get the database file path
      final dbPath = await _database.getDatabasePath();
      final dbFile = File(dbPath);
      final backupFile = File(filePath);

      // Create backup of current database before restoring
      final tempBackupPath = '${dbPath}.temp_backup';
      if (await dbFile.exists()) {
        await dbFile.copy(tempBackupPath);
      }

      try {
        // Copy backup file to database location
        await backupFile.copy(dbPath);

        // Delete temp backup on success
        final tempBackup = File(tempBackupPath);
        if (await tempBackup.exists()) {
          await tempBackup.delete();
        }

        content.remove(content.last);
        content.add(textWidget('Database restored successfully'));

        AlertMessage.snakMessage(
          'Database restored! Please restart the application.',
          context,
        );
      } catch (e) {
        // Restore original database on failure
        final tempBackup = File(tempBackupPath);
        if (await tempBackup.exists()) {
          await tempBackup.copy(dbPath);
          await tempBackup.delete();
        }
        throw e;
      }
    } catch (e) {
      content.clear();
      AlertMessage.snakMessage(
        'Failed to restore database: ${e.toString()}',
        context,
      );
    }
  }

  /// Create a backup of the database
  Future<void> backupDBFile(BuildContext context) async {
    content.clear();

    // Generate default backup filename with timestamp
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final defaultFileName = 'pos_backup_$timestamp.db';

    // Let user choose save location
    final result = await FilePicker.platform.saveFile(
      fileName: defaultFileName,
      dialogTitle: 'Save Backup As',
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result == null) {
      content.clear();
      AlertMessage.snakMessage('Backup cancelled', context);
      return;
    }

    try {
      content.add(ProgressingDots(text: 'Creating database backup...'));

      // Get the current database file path
      final dbPath = await _database.getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }

      // Ensure database is flushed to disk
      await _database.customStatement('PRAGMA wal_checkpoint(FULL)');

      // Copy database file to backup location
      await dbFile.copy(result);

      content.remove(content.last);
      content.add(textWidget('Backup created successfully'));

      AlertMessage.snakMessage('Backup saved to $result', context);
    } catch (e) {
      content.clear();
      AlertMessage.snakMessage(
        'Failed to create backup: ${e.toString()}',
        context,
      );
    }
  }

  /// Reset database by deleting all data
  Future<void> resetDatabase(BuildContext context) async {
    content.clear();

    try {
      content.add(ProgressingDots(text: 'Deleting all data...'));

      // Delete all data from all tables
      await _database.transaction(() async {
        // Delete in order to respect foreign key constraints
        await _database.delete(_database.payments).go();
        await _database.delete(_database.invoiceItems).go();
        await _database.delete(_database.extraCharges).go();
        await _database.delete(_database.invoices).go();

        await _database.delete(_database.supplierInvoiceItems).go();
        await _database.delete(_database.supplierInvoices).go();

        await _database.delete(_database.customers).go();
        await _database.delete(_database.suppliers).go();
        await _database.delete(_database.items).go();

        await _database.delete(_database.extraChargeTemplates).go();
        await _database.delete(_database.commentTemplates).go();
      });

      content.remove(content.last);
      content.add(textWidget('All data deleted successfully'));

      AlertMessage.snakMessage('Database reset complete', context);
    } catch (e) {
      content.clear();
      AlertMessage.snakMessage(
        'Failed to reset database: ${e.toString()}',
        context,
      );
    }
  }

  Widget textWidget(String text) {
    return Row(children: [
      Icon(
        Icons.done_rounded,
        color: Colors.green.shade700,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    ]);
  }
}
