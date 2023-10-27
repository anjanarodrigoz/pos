import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/setup/backup_page.dart';
import 'package:pos/Pages/setup/company_details_page.dart';
import 'package:pos/database/main_db.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_appbar.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:pos/widgets/rounded_icon_button.dart';
import 'package:pos/widgets/verify_dialog.dart';

import 'email_setup_page.dart';

class SetupHomePage extends StatefulWidget {
  const SetupHomePage({super.key});

  @override
  State<SetupHomePage> createState() => _SetupHomePageState();
}

class _SetupHomePageState extends State<SetupHomePage> {
  @override
  void initState() {
    super.initState();
    displayWidget = const CompanyDetailsPage();
  }

  Widget? displayWidget;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PosAppBar(title: 'Setup'),
        body: Row(
          children: [
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    RoundedIconButton(
                        icon: Icons.business,
                        onPressed: () {
                          displayWidget = const CompanyDetailsPage();
                          setState(() {});
                        }),
                    RoundedIconButton(
                        icon: Icons.storage,
                        onPressed: () {
                          displayWidget = const BackupPage();
                          setState(() {});
                        }),
                    RoundedIconButton(
                        icon: Icons.email_rounded,
                        onPressed: () {
                          displayWidget = const EmailSetupPage();
                          setState(() {});
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 62,
              height: MediaQuery.of(context).size.height,
              child: displayWidget,
            )
          ],
        ));
  }
}
