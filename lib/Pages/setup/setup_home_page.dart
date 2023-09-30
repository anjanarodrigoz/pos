import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/database/main_db.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:pos/widgets/progressing_dot.dart';
import 'package:pos/widgets/verify_dialog.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../../widgets/deleteing_animation.dart';
import '../main_window.dart';

class SetupHomePage extends StatefulWidget {
  const SetupHomePage({super.key});

  @override
  State<SetupHomePage> createState() => _SetupHomePageState();
}

class _SetupHomePageState extends State<SetupHomePage> {
  dynamic data;
  TextEditingController controller = TextEditingController();
  MainDB dbContoller = Get.put(MainDB());
  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(500, 500), size: Size(700, 500), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.offAll(const MainWindow());
              },
              icon: Icon(Icons.arrow_back_outlined)),
          backgroundColor: TColors.blue,
          title: const Text('Setup')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PosButton(
                    icon: Icons.backup_rounded,
                    text: 'Backup Data',
                    onPressed: () async {
                      await dbContoller.backupDBFile(context);
                      data = '';
                      setState(() {});
                    }),
                PosButton(
                    icon: Icons.restore_page_rounded,
                    text: 'Upload Data',
                    onPressed: () async {
                      await dbContoller.readDBFile(context);
                      setState(() {});
                    }),
                PosButton(
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
            onContinue: (string) async {
              Get.back();
              await dbContoller.resetDatabase(context);
            },
            verifyText: 'DELETE MY ALL DATA')));
  }

  Widget showContent() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(40),
        width: double.maxFinite,
        child: Obx(() {
          return Column(
            children: dbContoller.content.value,
          );
        }),
      ),
    );
  }
}
