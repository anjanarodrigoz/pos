import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../database/main_db.dart';
import '../../widgets/pos_button.dart';
import '../../widgets/verify_dialog.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  dynamic data;

  MainDB dbContoller = Get.put(MainDB());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PosButton(
                      width: 160.0,
                      icon: Icons.backup_rounded,
                      text: 'Backup Data',
                      onPressed: () async {
                        await dbContoller.backupDBFile(context);
                        data = '';
                        setState(() {});
                      }),
                  PosButton(
                      width: 160.0,
                      icon: Icons.restore_page_rounded,
                      text: 'Upload Data',
                      onPressed: () async {
                        await dbContoller.readDBFile(context);
                        setState(() {});
                      }),
                  PosButton(
                      width: 180.0,
                      color: Colors.red.shade800,
                      icon: Icons.restore_from_trash,
                      text: 'Delete Database',
                      onPressed: () async {
                        await verify();
                      }),
                ],
              ),
              showContent()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verify() async {
    showDialog(
        context: context,
        builder: ((context) => POSVerifyDialog(
            color: Colors.red.shade900,
            continueText: 'Delete',
            title: 'Warning!',
            content:
                'Your data will be deleted if you continue.\nAre you sure you want to proceed?',
            onContinue: () async {
              Get.back();
              await dbContoller.resetDatabase(context);
            },
            verifyText: 'DELETE MY ALL DATA')));
  }

  Widget showContent() {
    return Container(
      margin: const EdgeInsets.all(40),
      width: double.maxFinite,
      child: Obx(() {
        return Column(
          children: dbContoller.content.value,
        );
      }),
    );
  }
}
