import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/widgets/pos_progress_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';

class EmailSendingDialog extends StatelessWidget {
  Function(String) onPressed;
  String? email;
  EmailSendingDialog({super.key, required this.onPressed, required this.email});

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = email ?? '';
    return AlertDialog(
      content: PosTextFormField(
        hintText: 'Enter email address',
        controller: emailController,
      ),
      actions: [
        POSProgressButton(
            text: 'Send',
            onPressed: () async {
              String email = emailController.text.toString().toLowerCase();
              await onPressed(email);
              Get.back();
            }),
      ],
    );
  }
}
