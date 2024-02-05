import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/widgets/pos_progress_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';

class EmailSendingDialog extends StatelessWidget {
  Function(String, String) onPressed;
  String? email;
  final bool isMessageRequired;
  EmailSendingDialog(
      {super.key,
      required this.onPressed,
      required this.email,
      this.isMessageRequired = false});

  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = email ?? '';
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PosTextFormField(
            hintText: 'Enter email address',
            controller: emailController,
          ),
          if (isMessageRequired)
            PosTextFormField(
              maxLines: 10,
              height: 100,
              hintText: 'Enter Message',
              controller: messageController,
            ),
        ],
      ),
      actions: [
        POSProgressButton(
            text: 'Send',
            onPressed: () async {
              String email = emailController.text.toString().toLowerCase();
              String message = messageController.text.toString();
              if (email.isNotEmpty) {
                await onPressed(email, message);
                Get.back();
              }
            }),
      ],
    );
  }
}
