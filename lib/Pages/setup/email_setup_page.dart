import 'package:flutter/material.dart';
import 'package:pos/api/email_sender.dart';
import 'package:pos/database/store_db.dart';
import 'package:pos/models/store.dart';
import 'package:pos/services/email_credentials_service.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/pos_progress_button.dart';
import 'package:pos/widgets/rounded_icon_button.dart';

import '../../widgets/pos_text_form_field.dart';

class EmailSetupPage extends StatefulWidget {
  const EmailSetupPage({super.key});

  @override
  State<EmailSetupPage> createState() => _EmailSetupPageState();
}

class _EmailSetupPageState extends State<EmailSetupPage> {
  TextEditingController senderEmailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Store store = Store(
      companyName: '',
      abn: '',
      street: '',
      city: '',
      state: '',
      postalcode: '',
      mobileNumber1: '',
      email: '',
      email2: '',
      smtpServer: '');

  @override
  void initState() {
    super.initState();
    store = StoreDB().getStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: RoundedIconButton(
          backgroundColor: Colors.green,
          icon: Icons.save,
          onPressed: () => saveData()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text('Email Setup'),
                        const SizedBox(
                          height: 10.0,
                        ),
                        PosTextFormField(
                          initialValue: store.email2,
                          onSaved: (value) => store.email2 = value!,
                          labelText: 'Email',
                        ),
                        PosTextFormField(
                          controller: passwordController,
                          obscureText: true,
                          labelText: 'Password',
                        ),
                        PosTextFormField(
                          onSaved: (value) => store.smtpServer = value!,
                          labelText: 'SMTP Server',
                          initialValue: store.smtpServer,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('Test Email'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      PosTextFormField(
                        controller: senderEmailController,
                        labelText: 'Sender email address',
                      ),
                      PosTextFormField(
                        controller: titleController,
                        labelText: 'Title',
                      ),
                      PosTextFormField(
                        controller: messageController,
                        labelText: 'Message',
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      POSProgressButton(
                        text: 'Send',
                        onPressed: () async => await testEmail(),
                        icon: Icons.send_outlined,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveData() async {
    _formKey.currentState!.save();

    // Save store data (without password)
    await StoreDB().addStore(store);

    // Save SMTP credentials securely
    if (passwordController.text.isNotEmpty) {
      await EmailCredentialsService.saveSmtpCredentials(
        username: store.email2,
        password: passwordController.text,
        server: store.smtpServer,
        port: 465, // Default SMTP SSL port
      );
    }

    if (context.mounted) {
      AlertMessage.snakMessage('email setup success', context);
    }
  }

  Future<void> testEmail() async {
    String sender = senderEmailController.text.toLowerCase().toString();
    String title = titleController.text.toString();
    String message = messageController.text.toString();

    await EmailSender.sendEmail(sender, context, title: title, body: message);
  }
}
