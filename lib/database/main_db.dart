import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:pos/database/abstract_db.dart';
import 'package:pos/database/commnets_db_service.dart';
import 'package:pos/database/credit_db_serive.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/database/extra_charges_db_service.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/database/quatation_db_serive.dart';
import 'package:pos/database/supplyer_db_service.dart';
import 'package:pos/database/supplyer_invoice_db_service.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/progressing_dot.dart';

class MainDB extends GetxController {
  List<AbstractDB> dbList = [];
  RxList<Widget> content = <Widget>[].obs;

  @override
  onInit() {
    super.onInit();
    content.clear();
  }

  MainDB() {
    dbList = [
      CommentsDB(),
      CreditNoteDB(),
      CustomerDB(),
      ExtraChargeDB(),
      InvoiceDB(),
      ItemDB(),
      QuotationDB(),
      SupplyerDB(),
      SupplyerInvoiceDB()
    ];
  }

  Future<void> readDBFile(BuildContext context) async {
    content.clear();
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['zip', 'db']
            // Specify the allowed file extension
            );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;

      final zipFile = File(filePath!);
      final destinationDir = Directory.current;

      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());

      for (final file in archive) {
        final filename = file.name;
        print(filename);
        if (file.isFile) {
          final data = file.content as List<int>;
          File('${destinationDir.path}/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data, flush: true);
        } else {
          Directory('${destinationDir.path}/$filename').create(recursive: true);
        }
      }

      try {
        content.add(ProgressingDots(text: 'Extracting backup.db file'));

        content.remove(content.last);

        for (AbstractDB db in dbList) {
          content.add(ProgressingDots(text: 'Uploading ${db.getName()} data'));
          final file = File('${destinationDir.path}/${db.getName()}.json');
          final fileContent = file.readAsStringSync();
          db.insertData(jsonDecode(fileContent));
          file.delete();
          content.remove(content.last);
          content.add(textWidget('${db.getName()} data was uploaded'));
        }
      } catch (e) {
        content.clear();
        AlertMessage.snakMessage('Something went wrong', context);
      }
    } else {
      // User canceled file selection
      content.clear();
      AlertMessage.snakMessage('Something went wrong', context);
    }
  }

  Future<void> backupDBFile(context) async {
    content.clear();
    final List<File> files = [];
    final sourceDir = Directory.current;
    final encoder = ZipFileEncoder();

    final result = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['.db'], // Specify the file type/extension
      fileName: 'backup.db',
      dialogTitle: 'Save File As',
      initialDirectory: Directory.current.path,
    );

    if (result != null) {
      encoder.create(result);
      try {
        for (AbstractDB db in dbList) {
          content
              .add(ProgressingDots(text: 'Creating ${db.getName()}.db file'));
          final json = await db.backupData();
          var file = File('${sourceDir.path}/${db.getName()}.json');
          file.writeAsStringSync(jsonEncode(json), flush: true);
          content.remove(content.last);
          content.add(textWidget('${db.getName()}.db file was created'));
          encoder.addFile(file);
        }
        content.add(ProgressingDots(text: 'Creating backup.db file'));
        encoder.close();

        // await ZipFile.createFromFiles(
        //     sourceDir: sourceDir, files: files, zipFile: zipFile);
        for (AbstractDB db in dbList) {
          var file = File('${sourceDir.path}/${db.getName()}.json');
          await file.delete();
        }
        content.remove(content.last);
        content.add(textWidget('backup.db file was created'));
        AlertMessage.snakMessage('File saved to $result', context);
      } catch (e) {
        content.clear();
      }
    }
  }

  Future<void> resetDatabase(BuildContext context) async {
    content.clear();
    content.add(ProgressingDots(text: 'Your data is deleting'));
    for (AbstractDB db in dbList) {
      await db.deleteDB();
    }
    content.remove(content.last);
    content.add(textWidget('Data deleted successfull'));
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
